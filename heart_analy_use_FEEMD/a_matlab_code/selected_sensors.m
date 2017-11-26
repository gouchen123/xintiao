classdef selected_sensors
    properties
    first_sensor_index = 0 ;
    second_sensor_index = 0 ;
    end
  methods
function result = selected_sensors(r,t)
                result.first_sensor_index = r;
                result.second_sensor_index = t;
end
  end
end