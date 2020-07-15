Select Top 1000000 tblAssets.AssetID,
  tblAssets.AssetName,
  tblAssetGroups.AssetGroup,
  tblAssets.Username,
  tblAssets.IPAddress,
  tblAssetCustom.Manufacturer,
  tblAssetCustom.Model,
  tHost.AssetName As [Hyper-V Host],
  tblAssets.Domain,
  Convert(nvarchar(10),Ceiling(Floor(Convert(integer,tblAssets.Uptime) / 3600 /
  24))) + ' days ' +
  Convert(nvarchar(10),Ceiling(Floor(Convert(integer,tblAssets.Uptime) / 3600 %
  24))) + ' hours ' +
  Convert(nvarchar(10),Ceiling(Floor(Convert(integer,tblAssets.Uptime) % 3600 /
  60))) + ' minutes' As UptimeSinceLastReboot,
  tblAssetCustom.PurchaseDate,
  tblAssetCustom.Warrantydate,
  Max(Convert(datetime,tblQuickFixEngineering.InstalledOn)) As LastPatchDate,
  tblDiskdrives.Caption As Drive,
  Cast(tblDiskdrives.Freespace / 1024 / 1024 / 1024 As numeric) As FreeGB,
  Cast(tblDiskdrives.Size / 1024 / 1024 / 1024 As numeric) As TotalSizeGB,
  Ceiling(tblDiskdrives.Freespace / (Case tblDiskdrives.Size
    When 0 Then 1
    Else tblDiskdrives.Size
  End) * 100) As [%SpaceLeft],
  Case
    When Ceiling(tblDiskdrives.Freespace / (Case tblDiskdrives.Size
        When 0 Then 1
        Else tblDiskdrives.Size
      End) * 100) < 10 Then '#f7caca'
    When Ceiling(tblDiskdrives.Freespace / (Case tblDiskdrives.Size
        When 0 Then 1
        Else tblDiskdrives.Size
      End) * 100) < 30 Then '#f7f0ca'
  End As backgroundcolor,
  tblDiskdrives.Lastchanged As LastChanged
From tblAssets
  Inner Join tblAssetCustom On tblAssets.AssetID = tblAssetCustom.AssetID
  Inner Join tblAssetGroupLink On tblAssets.AssetID = tblAssetGroupLink.AssetID
  Inner Join tblAssetGroups On tblAssetGroups.AssetGroupID =
    tblAssetGroupLink.AssetGroupID
  Inner Join tblQuickFixEngineering On
    tblAssets.AssetID = tblQuickFixEngineering.AssetID
  Inner Join tblDiskdrives On tblAssets.AssetID = tblDiskdrives.AssetID
  Inner Join tblState On tblState.State = tblAssetCustom.State
  Left Join TblHyperVGuestNetwork On
    tblAssets.Mac = TblHyperVGuestNetwork.MacAddress
  Left Join tblHyperVGuest On tblHyperVGuest.hypervguestID =
    TblHyperVGuestNetwork.HyperVGuestID
  Left Join tblAssets tHost On tHost.AssetID = tblHyperVGuest.AssetID
Where tblAssetGroups.AssetGroup = 'CAD Servers' And Cast(tblDiskdrives.Size /
  1024 / 1024 / 1024 As numeric) <> 0 And tblAssetCustom.State = 1 And
  tblState.Statename = 'Active' And Case tblDiskdrives.DriveType
    When 3 Then 'Local Disk'
  End = 'Local Disk'
Group By tblAssets.AssetID,
  tblAssets.AssetName,
  tblAssetGroups.AssetGroup,
  tblAssets.Username,
  tblAssets.IPAddress,
  tblAssetCustom.Manufacturer,
  tblAssetCustom.Model,
  tblAssets.Domain,
  Convert(nvarchar(10),Ceiling(Floor(Convert(integer,tblAssets.Uptime) / 3600 /
  24))) + ' days ' +
  Convert(nvarchar(10),Ceiling(Floor(Convert(integer,tblAssets.Uptime) / 3600 %
  24))) + ' hours ' +
  Convert(nvarchar(10),Ceiling(Floor(Convert(integer,tblAssets.Uptime) % 3600 /
  60))) + ' minutes',
  tblAssetCustom.PurchaseDate,
  tblAssetCustom.Warrantydate,
  tblDiskdrives.Caption,
  Cast(tblDiskdrives.Freespace / 1024 / 1024 / 1024 As numeric),
  Cast(tblDiskdrives.Size / 1024 / 1024 / 1024 As numeric),
  Ceiling(tblDiskdrives.Freespace / (Case tblDiskdrives.Size
    When 0 Then 1
    Else tblDiskdrives.Size
  End) * 100),
  Case
    When Ceiling(tblDiskdrives.Freespace / (Case tblDiskdrives.Size
        When 0 Then 1
        Else tblDiskdrives.Size
      End) * 100) < 10 Then '#f7caca'
    When Ceiling(tblDiskdrives.Freespace / (Case tblDiskdrives.Size
        When 0 Then 1
        Else tblDiskdrives.Size
      End) * 100) < 30 Then '#f7f0ca'
  End,
  tblDiskdrives.Lastchanged,
  tHost.AssetName,
  tblAssets.IPNumeric
Order By tblAssets.IPNumeric,
  tblAssetGroups.AssetGroup