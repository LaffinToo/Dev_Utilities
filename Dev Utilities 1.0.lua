-- Author: RoKoDerBoss 2020
-- Stats / Vars--
regCount = 0
snapCount = 0
swipeCount = 0
Dir = scriptPath()
imgDir = Dir.."/snaps"
-- User Dialog / General --
function initialUserInterface()
    dialogInit()
        addTextView("Welcome to Dev Utilities 1.0 - Choose an Action")
        newRow()
        addTextView(" ")
        newRow()
        addTextView("Action:")
            local actionChoice = {"Region Finder","Swipe Finder","Take Snapshot"}
        addSpinner("action",actionChoice,"Region Finder")
        addTextView("        ")
        addTextView("Device Resolution:")
            local resolutions = {"1280 x 720", "..."}
        addSpinner("resolution",resolutions, "1280 x 720")
        newRow()
        addTextView(" ")
        addSeparator()
    dialogShow("Dev Utilities 1.0")
end
function setCompareDimension()
    if resolution == "1280 x 720" then
        resolution = 720
        Settings:setCompareDimension(true, resolution)
    else
        scriptExit("Resolution not supported")
    end
end
function showCount(show)
    local regStatBox = Region(1170, 136, 107, 91)

    if show == true then
        setHighlightTextStyle(16777215, 4294967295, 10)
        regStatBox:highlight("Region No: "..tostring(regCount).."\nSwipe No: "..tostring(swipeCount).."\nSnapshots: "..tostring(snapCount))
    elseif show == false then
        regStatBox:highlightOff()
    end
end
function refreshCount()
    local regStatBox = Region(1170, 136, 107, 91)

    regStatBox:highlightOff()
    wait(.1)
    setHighlightTextStyle(16777215, 4294967295, 10)
    regStatBox:highlight("Region No: "..tostring(regCount).."\nSwipe No: "..tostring(swipeCount).."\nSNapshots: "..tostring(snapCount))
end
-- Update Script --
function UpdateScript()
    local getNewestVersion = loadstring(httpGet("https://raw.githubusercontent.com/RoKoDerBoss/Dev_Utilities/master/Dev%20Utilities%201.0.lua"))
    latestVersion = getNewestVersion()
    currentVersion = dofile(localPath .."Dev Utilities 1.0.lua")
    if currentVersion == latestVersion then
        toast ("You are running the most current version!")
    else
        --httpDownload("https://raw.githubusercontent.com/Paladiex/PalPowerUp/master/version.lua", localPath .."version.lua")
        httpDownload("https://raw.githubusercontent.com/RoKoDerBoss/Dev_Utilities/master/Dev%20Utilities%201.0.lua", localPath .."Dev Utilities 1.0.lua")
        scriptExit("You have Updated the Script!")
    end
end
-- Region Finder --
function regionFinder()

    regCount = regCount + 1
    refreshCount()

    toast("Click Upper Left Corner of Target Region")
    local action, one, touchTable = getTouchEvent()
    wait(.75)
    toast("Click Lower Right Corner of Target Region")
    local action, two, touchTable = getTouchEvent()

    onex = one:getX()
    oney = one:getY()
    twox = two:getX()
    twoy = two:getY()
    width = twox - onex
    height = twoy - oney
    newRegion = Region(onex, oney, width, height)

    --toast("Region" .. regCount .. ": X = ".. regionOneX .. ", Y = ".. regionOneY  .. ", W = " .. width .. ", H = " .. height)
    print("Region Result:")
    print("Region" .. regCount .. ": (".. newRegion:getX() .. ", ".. newRegion:getY()  .. ", " .. newRegion:getW() .. ", " .. newRegion:getH() .. ")")
    newRegion:highlight(2)
end
function resultDialogRegion()
    dialogInit()
        removePreference("RegionName")
        removePreference("rgIndex")
        addTextView(" ")
        newRow()
        addTextView("Region" .. regCount .. ": (".. onex .. ", ".. oney  .. ", " .. width .. ", " .. height .. ")")
        newRow()
        newRow()
        addTextView("Copy New Region: ")
        addEditText("RegionName", "= Region("..onex..", "..oney..", "..width..", "..height..")")
        newRow()
        addTextView(" ")
        newRow()
        addSeparator()
        newRow()
        addTextView("Next Step:")
        newRow()
        addRadioGroup("rgIndex", 1)
        addRadioButton("Next Region", 1)
        addRadioButton("Swipe Finder", 2)
        addRadioButton("Take Snapshot",3)
        addRadioButton("Back to Main Menu",4)
        addRadioButton("Exit Script", 5)

    dialogShowFullScreen("Results")
end
-- Swipe Finder --
function SwipeFinder()

    swipeCount = swipeCount + 1
    refreshCount()

    toast("Do Target Swipe")
    local action, swipe, touchTable = getTouchEvent()

    locStartX = swipe[1]:getX()
    locStartY = swipe[1]:getY()
    locEndX = swipe[2]:getX()
    locEndY = swipe[2]:getY()

    -- print Start & End Location
    print("Swipe Result:")
    print("Start Location" .. swipeCount .. ": " .. locStartX .. ", " .. locStartY .. "\nEnd Location" .. swipeCount ..": " .. locEndX .. ", " .. locEndY)

    -- show Swipe as Region
    local width = locEndX - locStartX
    local showRegion = Region(locStartX, locStartY - 10, width, 20)
    showRegion:highlight(2)
end
function resultDialogSwipe()
    dialogInit()
    removePreference("SwipeName")
    removePreference("swIndex")
    addTextView(" ")
    newRow()
    addTextView("Start Location" .. swipeCount .. ": " .. locStartX .. ", " .. locStartY .. "\nEnd Location" .. swipeCount ..": " .. locEndX .. ", " .. locEndY)
    newRow()
    addTextView(" ")
    newRow()
    addTextView("Copy New Swipe Locations: ")
    addEditText("SwipeName", "= swipe(Location("..locStartX..", "..locStartY.."),Location("..locEndX..", "..locEndY.."))")
    newRow()
    addTextView(" ")
    newRow()
    addSeparator()
    newRow()
    addTextView("Next Step:")
    newRow()
    addRadioGroup("swIndex", 1)
    addRadioButton("Next Swipe", 1)
    addRadioButton("Region Finder", 2)
    addRadioButton("Take Snapshot",3)
    addRadioButton("Back to Main Menu",4)
    addRadioButton("Exit Script", 5)

    dialogShowFullScreen("Results")
end
-- Take Snapshot --
function preDialogSnap()

    dialogInit()
    removePreference("customW")
    removePreference("customH")
    addTextView("Size Setting:")
    addTextView("                                ")
    addTextView("custom Size Setting:")
    newRow()
    local snapSizes = {"10 x 10","20 x 20","30 x 30","40 x 40", "50 x 50","60 x 60","70 x 70","80 x 80","90 x 90","100 x 100"}
    addSpinner("snapSize",snapSizes,"10 x 10")
    addTextView("                        ")
    addTextView("Width: ") addEditNumber("customW",0)
    addTextView("  Height: ") addEditNumber("customH",0)
    addTextView(" ")
    newRow()
    addTextView("Show Snapshot Region for:") addEditNumber("showRegionTime",3) addTextView(" Seconds")
    addSeparator()
    dialogShow("Snapshot Settings:")

    if customW == 0 and customH == 0 then
        for i=1,10 do
            if snapSize == snapSizes[i] then
                snapSize =  i..0
            end
        end
    else
        customW = customW*2
        customH = customH*2
    end
end
function TakeSnapshot()

    snapCount = snapCount + 1
    refreshCount()

    toast("Click Area to take Snapshot")
    local action, snap, touchTable = getTouchEvent()

    if customW == 0 and customH == 0 then
        snapX = snap:getX() - (snapSize*2 / 2)
        snapY = snap:getY() - (snapSize*2 / 2)
        snapW = tonumber(snapSize*2)
        snapH = tonumber(snapSize*2)
    else
        snapX = snap:getX() - (customW / 2)
        snapY = snap:getY() - (customH / 2)
        snapW = customW
        snapH = customH
    end

    local snapRegion = Region(snapX, snapY, snapW, snapH)

    snapRegion:highlight(showRegionTime)

    DialogSnap()

    if snapshotPreviewChoice == "Yes" then
        if colorChoice == "Black & White" then
            print("Snapshot Result:")
            print("Snapshot Name: "..snapName)
            setImagePath(imgDir)
            snapRegion:save(snapName .. ".png")
            setImagePath(Dir)
        else
            print("Snapshot Result:")
            print("Snapshot Name: "..snapName)
            setImagePath(imgDir)
            snapRegion:saveColor(snapName .. ".png")
            setImagePath(Dir)
        end
    end
end
function DialogSnap()
    dialogInit()
    removePreference("snapName")
    local YesNo = {"Yes","No"}
    addTextView("Save this Snapshot:")
    addSpinner("snapshotPreviewChoice",YesNo,"Yes")
    addTextView("       ")
    addTextView("File Name:")
    addEditText("snapName","")
    newRow()
    addTextView("Snapshot Quality:")
    local colorOption = {"Black & White","Color"}
    addSpinner("colorChoice",colorOption,"Color")
    dialogShow("Save Snapshot?")
end
function resultDialogSnap()
    dialogInit()
    removePreference("snapNameCopy")
    removePreference("snIndex")
    addTextView(" ")
    newRow()
    addTextView("Snapshot Name: " .. snapName)
    newRow()
    addTextView(" ")
    newRow()
    addTextView("Copy New Pattern: ")
    addEditText("snapNameCopy", "= Pattern(\""..snapName..".png\"):similar(.7)")
    newRow()
    addTextView(" ")
    newRow()
    addSeparator()
    newRow()
    addTextView("Next Step:")
    newRow()
    addRadioGroup("snIndex", 1)
    addRadioButton("Next Snapshot", 1)
    addRadioButton("Region Finder", 2)
    addRadioButton("Swipe Finder",3)
    addRadioButton("Back to Main Menu",4)
    addRadioButton("Exit Script", 5)

    dialogShowFullScreen("Results")
end
-- Script --
UpdateScript()
initialUserInterface()
setCompareDimension()

showCount(true)

while true do
    if action == "Region Finder" then
        while true do
            regionFinder()
            resultDialogRegion()
            if rgIndex == 1 then -- Next
                regCount = regCount + 1
            elseif rgIndex == 2 then -- Swipe
                action = "Swipe Finder"
                break
            elseif rgIndex == 3 then --Snapshot
                action = "Take Snapshot"
                break
            elseif rgIndex == 4 then -- Menu
                initialUserInterface()
                break
            else
                scriptExit()
            end
        end
    elseif action == "Swipe Finder" then
        while true do
            SwipeFinder()
            resultDialogSwipe()
            if swIndex == 1 then --Next Swipe
                swipeCount = swipeCount + 1
            elseif swIndex == 2 then -- Region
                action = "Region Finder"
                break
            elseif swIndex == 3 then --Snapshot
                action = "Take Snapshot"
                break
            elseif swIndex == 4 then -- Menu
                initialUserInterface()
                break
            else
                scriptExit()
            end
        end
    elseif action == "Take Snapshot" then
        while true do
            preDialogSnap()
            TakeSnapshot()
            if snapshotPreviewChoice == "Yes" then
                resultDialogSnap()
            else
                snIndex = 1
            end
            if snIndex == 1 then --Next Snapshot
                snapCount = snapCount + 1
            elseif snIndex == 2 then -- Region
                action = "Region Finder"
                break
            elseif snIndex == 3 then --Swipe
                action = "Swipe Finder"
                break
            elseif snIndex == 4 then -- Menu
                initialUserInterface()
                break
            else
                scriptExit()
            end
        end
    end
end