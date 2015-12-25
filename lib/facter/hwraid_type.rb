Facter.add('hwraid_type') do
    if Facter.value(:has_aacraid)
        retval = "aac"
    else
        retval = false
    end

    setcode do
        retval
    end
end
