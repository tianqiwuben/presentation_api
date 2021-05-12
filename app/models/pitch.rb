class Pitch < ApplicationRecord

    include Rails.application.routes.url_helpers

    has_one_attached :attachment
    has_many_attached :thumbs
    has_many_attached :images

    STATUS = {
        init: 0,
        processing: 1,
        done: 2,
    }

    self.per_page = 10


    def file_path
        return @file_path if @file_path
        @file_path = ActiveStorage::Blob.service.path_for(attachment.key)
    end


    def thumb_url(first_only = true)
        if first_only
            return "" unless self.thumbs.attached?
            return url_for(self.thumbs[0])
        else
            return self.thumbs.map {|thumb| url_for(thumb)}
        end
    end
    

    def images_url
        return self.images.map {|img| url_for(img)}
    end


    def self.generate_image(id)
        pitch = Pitch.find_by id: id
        return if pitch.blank? || !pitch.attachment.attached?
        return unless pitch.status == STATUS[:init]
        pitch.status = STATUS[:processing]
        pitch.save

        if pitch.thumbs.attached?
            pitch.thumbs.each do |thumb|
                thum.purge
            end
        end

        if pitch.images.attached?
            pitch.images.each do |img|
                img.purge
            end
        end

        if pitch.attachment.content_type == "application/pdf"
            im = Magick::Image.read(pitch.file_path)
            im.each_with_index do |img, idx|
                img_path = "#{pitch.file_path}_#{idx}.png"
                img.write(img_path)
                pitch.images.attach(io: File.open(img_path), filename: "preview_#{idx}.png")
                File.delete img_path
                img_path = "#{pitch.file_path}_t_#{idx}.png"
                thumb_img = img.resize_to_fit(320, 240)
                thumb_img.write img_path
                pitch.thumbs.attach(io: File.open(img_path), filename: "thumb_#{idx}.png")
                File.delete img_path
            end
        else
            configuration = AsposeSlidesCloud::Configuration.new
            configuration.app_sid = Rails.application.credentials.appose[:sid]
            configuration.app_key = Rails.application.credentials.appose[:key]
            api = AsposeSlidesCloud::SlidesApi.new(configuration)
            origin_file = pitch.file_path
            file_path = "#{Rails.root}/tmp/storage/#{Time.now.to_f}/"
            Dir.mkdir(file_path)
            result = api.convert(File.binread(origin_file), "Jpeg")
            zip_file = file_path + "converted.zip"
            File.binwrite(zip_file, result)
            require 'zip'
            Zip::File.open(zip_file) do |zipfile|
                zipfile.each do |file|
                    img_path = file_path + file.name
                    file.extract(img_path)
                    pitch.images.attach(io: File.open(img_path), filename: file.name)
                    im = Magick::Image.read(img_path)
                    img_path = "#{file_path}/t_#{file.name}"
                    thumb_img = im[0].resize_to_fit(320, 240)
                    thumb_img.write img_path
                    pitch.thumbs.attach(io: File.open(img_path), filename: "t_#{file.name}")
                end
            end
            FileUtils.rm_r(file_path)
        end
        pitch.status = STATUS[:done]
        pitch.save
    end

    def as_json(options = {})
        data = {
            id: self.id,
            filename: self.filename,
            created_at: self.created_at,
            updated_at: self.updated_at,
            thumb_url: self.thumb_url,
            download_url: rails_blob_url(self.attachment, disposition: "attachment"),
            status: self.status,
        }
        if options[:details]
            data[:images] = self.images_url
            data[:thumbs] = self.thumb_url(false)
        end
        data
    end

end
