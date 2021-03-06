class IeducarConfigurationsController < ApplicationController
  def edit
    @configuration = IeducarConfiguration.find_or_initialize_by(id: params[:id])
  end

  def update
    @configuration = IeducarConfiguration.find_or_initialize_by(id: params[:id])
    @configuration.attributes = permitted_attributes

    if @configuration.save
      redirect_to edit_ieducar_configuration_path
    else
      render :edit
    end
  end

  private

  def permitted_attributes
    params.require(:ieducar_configuration).permit(:url, :token)
  end
end