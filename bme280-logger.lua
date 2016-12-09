-- bme280 ----------------------------------------------------------------

SAMPLE_FREQ         = 10000  -- how often to sample sensors (ms)
REPORT_PERIOD       = 6      -- report every N samples
AVG_PERIOD          = 6      -- moving average of N samples

countdown_to_report = 0      -- number of samples until next report
sample_count        = 0      -- how many sampless in the average
avg_temp            = 0      -- current average temp
-- avg_humi            = 0      -- current average humidity


function readsensors()
    if sample_count < AVG_PERIOD then
        sample_count = sample_count + 1
    end

    if sample_count == 1 then
        local res = bme280.init(PIN_SDA, PIN_SCL)
        print("Initialized BME280: "..res)
    end

    local temp = bme280.temp()

    if temp == nil then
        print("Error reading temperature.")
        return
    end

    temp = temp * 9 / 500 + 32; -- convert to fahrenheit and divide by 100
    avg_temp = avg_temp + (temp - avg_temp) / sample_count
    -- avg_humi = avg_humi + (humi - avg_humi) / sample_count

    if countdown_to_report == 0 then
        countdown_to_report = REPORT_PERIOD
        print("temperature: "..avg_temp)
        local msg = string.format('{"temperature":%0.1f,"zone":%d}', avg_temp, config.zone)
        m:publish(config.mqtt_prefix .. "/sensors", msg, 0, 0)
    end

    countdown_to_report = countdown_to_report - 1
end

tmr.alarm(TIMER_SENSORS, SAMPLE_FREQ, tmr.ALARM_AUTO, readsensors)
