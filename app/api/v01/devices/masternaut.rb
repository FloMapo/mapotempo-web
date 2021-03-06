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
class V01::Devices::Masternaut < Grape::API
  namespace :devices do
    namespace :masternaut do
      before do
        @customer = current_customer params[:customer_id]
      end

      rescue_from DeviceServiceError do |e|
        error! e.message, 200
      end

      helpers do
        def service
          MasternautService.new customer: @customer
        end
      end

      desc 'Send Route',
        detail: 'Send Route',
        nickname: 'deviceMasternautSend'
      params do
        requires :route_id, type: Integer, desc: 'Route ID'
      end
      post '/send' do
        device_send_route
      end

      desc 'Send Planning Routes',
        detail: 'Send Planning Routes',
        nickname: 'deviceMasternautSendMultiple'
      params do
        requires :planning_id, type: Integer, desc: 'Planning ID'
      end
      post '/send_multiple' do
        device_send_routes device_id: :masternaut_ref
      end
    end
  end
end
