class PitchesController < ApplicationController
  before_action :set_pitch, only: %i[ show update destroy ]

  # GET /pitches
  # GET /pitches.json
  def index
    @pitches = Pitch.all
  end

  # GET /pitches/1
  # GET /pitches/1.json
  def show
  end

  # POST /pitches
  # POST /pitches.json
  def create
    @pitch = Pitch.new(pitch_params)

    if @pitch.save
      render :show, status: :created, location: @pitch
    else
      render json: @pitch.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pitches/1
  # PATCH/PUT /pitches/1.json
  def update
    if @pitch.update(pitch_params)
      render :show, status: :ok, location: @pitch
    else
      render json: @pitch.errors, status: :unprocessable_entity
    end
  end

  # DELETE /pitches/1
  # DELETE /pitches/1.json
  def destroy
    @pitch.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pitch
      @pitch = Pitch.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pitch_params
      params.fetch(:pitch, {})
    end
end
