class PitchesController < ApplicationController
  before_action :set_pitch, only: %i[ update destroy ]

  # GET /pitches
  # GET /pitches.json
  def index
    @pitches = Pitch.page(params[:page]).order(id: :desc)
    rv = {
      items: @pitches.map {|pitch| pitch.as_json},
      total_pages: @pitches.total_pages,
    }
    api_success rv
  end

  # GET /pitches/1
  # GET /pitches/1.json
  def show
    if params[:id] == 'latest'
      @pitch = Pitch.last
    else
      @pitch = Pitch.find(params[:id])
    end
    if params[:view] == 'invest'
      api_success @pitch.as_json(details: true)
    else
      api_success @pitch.as_json
    end
  end

  # POST /pitches
  # POST /pitches.json
  def create
    @pitch = Pitch.new
    @pitch.attachment.attach(params[:file])
    @pitch.filename = params[:file].original_filename
    if @pitch.save
      PitchWorker.perform_async 'generate_image', @pitch.id
      api_success @pitch.as_json
    else
      api_fail @pitch.errors, :unprocessable_entity
    end
  end

  # PATCH/PUT /pitches/1
  # PATCH/PUT /pitches/1.json
  def update
    if @pitch.update(pitch_params)
      api_success
    else
      api_fail @pitch.errors, :unprocessable_entity
    end
  end

  # DELETE /pitches/1
  # DELETE /pitches/1.json
  def destroy
    @pitch.destroy
    api_success
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pitch
      @pitch = Pitch.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pitch_params
      params.fetch(:pitch, {}).permit(:attachment)
    end
end
