Facter.add('has_aacraid') do

    confine :kernel => 'Linux'

    setcode do
        retval = false
        File.open("/proc/devices", "r") do |devices|
            while (device = devices.gets)
                if device.match(/ aac$/)
                    retval = true
                    break
                end
            end
        end
        retval
    end
end
