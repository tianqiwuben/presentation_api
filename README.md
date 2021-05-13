# PDF & POWERPOINT to Image Converter

Live demo: http://54.87.32.174:3000/

This project takes upload and convert them into images.

For PDF, backend use RMagick for conversion.
For powerpoint, it uses https://www.aspose.cloud/ for conversion.

Since Aspose supports bunch of file types like Word, Excel, Diagram, CAD and video, this project can easily accommodate these use as well. For demonstration purpose, I'm only allowing powerpoint for now.

# Features

- Responsive webpage that optimized for both desktop and mobile web
- Infinite scroll grid for displaying uploaded pitches with thumbnail
- Progress indicator for upload 
- Background file processing (Sidekiq)
- Google drive style file management
- Select/Deselect, upload, delete, download, view and double click in the gallery view
- Carousel image slider in doc detail view
- In-sync thumbnails in doc detail view that is scrollable and selectable

# Tech stack
Frontend: React with Next.js.  https://github.com/tianqiwuben/presentation_web
Backend: Ruby on Rails  https://github.com/tianqiwuben/presentation_api
