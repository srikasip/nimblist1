class MailgunsController < ApplicationController
  before_action :set_mailgun, only: [:show, :edit, :update, :destroy]

  # GET /mailguns
  # GET /mailguns.json
  def index
    @mailguns = Mailgun.all
  end

  # GET /mailguns/1
  # GET /mailguns/1.json
  def show
  end

  # GET /mailguns/new
  def new
    @mailgun = Mailgun.new
  end

  # GET /mailguns/1/edit
  def edit
  end

  # POST /mailguns
  # POST /mailguns.json
  def create
    @mailgun = Mailgun.new(mailgun_params)

    respond_to do |format|
      if @mailgun.save
        format.html { redirect_to @mailgun, notice: 'Mailgun was successfully created.' }
        format.json { render action: 'show', status: :created, location: @mailgun }
      else
        format.html { render action: 'new' }
        format.json { render json: @mailgun.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mailguns/1
  # PATCH/PUT /mailguns/1.json
  def update
    respond_to do |format|
      if @mailgun.update(mailgun_params)
        format.html { redirect_to @mailgun, notice: 'Mailgun was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @mailgun.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mailguns/1
  # DELETE /mailguns/1.json
  def destroy
    @mailgun.destroy
    respond_to do |format|
      format.html { redirect_to mailguns_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mailgun
      @mailgun = Mailgun.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mailgun_params
      params.require(:mailgun).permit(:sender, :recipient, :subject, :stripped-text)
    end
end
