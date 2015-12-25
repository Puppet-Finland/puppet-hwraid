Facter.add('has_aacraid') do

    confine :kernel => 'Linux'

    retval = false
    File.open("/proc/devices", "r") do |devices|
        while (device = devices.gets)
            if device.match(/ aac$/)
                retval = true
                break
            end
        end
    end

    setcode do
        retval
    end
end
