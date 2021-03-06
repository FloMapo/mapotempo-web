# Copyright © Mapotempo, 2016
#
# This file is part of Mapotempo.
#
# Mapotempo is free software. You can redistribute it and/or
# modify since you respect the terms of the GNU Affero General
# Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.
#
# Mapotempo is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the Licenses for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Mapotempo. If not, see:
# <http://www.gnu.org/licenses/agpl.html>
#
class DeliverableUnitsController < ApplicationController
  load_and_authorize_resource
  before_action :set_deliverable_unit, only: [:edit, :update, :destroy]

  def index
    @deliverable_units = current_user.customer.deliverable_units
  end

  def new
    @deliverable_unit = current_user.customer.deliverable_units.build
  end

  def edit
  end

  def create
    respond_to do |format|
      DeliverableUnit.transaction do
        @deliverable_unit = current_user.customer.deliverable_units.build(deliverable_unit_params)
        if current_user.customer.save
          format.html { redirect_to deliverable_units_path, notice: t('activerecord.successful.messages.created', model: @deliverable_unit.class.model_name.human) }
        else
          format.html { render action: 'new' }
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @deliverable_unit.update(deliverable_unit_params) && @deliverable_unit.customer.save
        format.html { redirect_to deliverable_units_path, notice: t('activerecord.successful.messages.updated', model: @deliverable_unit.class.model_name.human) }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @deliverable_unit.destroy && current_user.customer.save
    respond_to do |format|
      format.html { redirect_to deliverable_units_url }
    end
  end

  def destroy_multiple
    DeliverableUnit.transaction do
      if params['deliverable_units']
        ids = params['deliverable_units'].keys.collect{ |i| Integer(i) }
        current_user.customer.deliverable_units.select{ |deliverable_unit| ids.include?(deliverable_unit.id) }.each(&:destroy)
        current_user.customer.save
      end
      respond_to do |format|
        format.html { redirect_to deliverable_units_url }
      end
    end
  end

  def duplicate
    respond_to do |format|
      @deliverable_unit = @deliverable_unit.duplicate
      @deliverable_unit.save!
      @deliverable_unit.customer.save
      format.html { redirect_to edit_deliverable_unit_path(@deliverable_unit), notice: t('activerecord.successful.messages.updated', model: @deliverable_unit.class.model_name.human) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_deliverable_unit
    @deliverable_unit = current_user.customer.deliverable_units.find params[:id] || params[:deliverable_unit_id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def deliverable_unit_params
    p = params.require(:deliverable_unit).permit(:label, :default_quantity, :default_capacity, :optimization_overload_multiplier)
  end
end
