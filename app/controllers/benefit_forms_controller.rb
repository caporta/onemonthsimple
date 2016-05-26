class BenefitFormsController < ApplicationController

  BASE_PATH = 'public/docs/'
  VALID_FILES = ["#{BASE_PATH}Health_n_Stuff.pdf", "#{BASE_PATH}Dental_n_Stuff.pdf"]

  def download
    begin
      if VALID_FILES.include?(params[:name]) && params[:type] == 'File'
        path = Rails.root.join(params[:name])
      else
        path = Rails.root.join(VALID_FILES[0])
      end
      file = params[:type].constantize.new(path)
      send_file file, disposition: 'attachment'
    rescue
      redirect_to user_benefit_forms_path(current_user.user_id)
    end
  end

  def index
    @benefits = Benefits.new
  end


  def upload
    file = params[:benefits][:upload]
    if file
      flash[:success] = "File Successfully Uploaded!"
      Benefits.save(file, params[:benefits][:backup])
    else
      flash[:error] = "Something went wrong"
    end
    redirect_to user_benefit_forms_path(:user_id => current_user.user_id)
  end
end
