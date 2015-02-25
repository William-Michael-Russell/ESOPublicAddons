function sampV(string)  --Verbose Logging
  --While developing apps you'll need logs, I use these logs and control it in the saved vars.
  -- If you release and a user has a major issue, which you can't reproduce. You can request them to enable logging..
  -- and send you the report ;)
  if mSampSavedVars.logV then
    d(sampleApp.var.color.colTeal .."SampleApp Verbose: "..sampleApp.var.color.colWhite .. string)
  end
end

function sampD(string)  --Debug logging
  -- This is used for debug logging. Once debug passes I usually change it into verbose for future problems.
  if mSampSavedVars.logD then
    d(sampleApp.var.color.colYellow .."SampleApp Debug: " .. sampleApp.var.color.colWhite .. string)
  end
end

function sampE(string)  --Error logging  
  -- BRIGHT RED TEXT TO ALERT YOU SOMETHING BAD HAPPENED. Put this where you never want your code to hit. 
  if mSampSavedVars.logE then
    d(sampleApp.var.color.colRed .."SampleApp Error: ".. sampleApp.var.color.colWhite .. string)
  end
end