Facter.add('hwraid_type') do

    confine :kernel => 'Linux'

    setcode do
        if Facter.value(:has_aacraid)
            retval = "aac"
        else
            retval = false
        end
        retval
    end
end
