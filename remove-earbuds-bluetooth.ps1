param (
    [string[]]$DeviceNames = @("Earfun", "T10")
)

[System.Reflection.Assembly]::LoadFrom("C:\Windows\Microsoft.NET\Framework64\v4.0.30319\System.Runtime.WindowsRuntime.dll") | Out-Null

$null = [Windows.Devices.Enumeration.DeviceInformation,Windows.Devices.Enumeration,ContentType=WindowsRuntime]
$null = [Windows.Devices.Bluetooth.BluetoothDevice,Windows.Devices.Bluetooth,ContentType=WindowsRuntime]

function Await($AsyncOp, $ResultType) {
    $asTask = [System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object {
        $_.Name -eq "AsTask" -and
        $_.IsGenericMethodDefinition -and
        $_.GetParameters().Count -eq 1 -and
        $_.GetParameters()[0].ParameterType.Name -eq "IAsyncOperation``1"
    } | Select-Object -First 1

    $asTaskGeneric = $asTask.MakeGenericMethod($ResultType)
    $task = $asTaskGeneric.Invoke($null, @($AsyncOp))
    $task.Wait()
    return $task.Result
}

foreach ($DeviceName in $DeviceNames) {
    Write-Host "Searching for: $DeviceName"

    $selector = [Windows.Devices.Bluetooth.BluetoothDevice]::GetDeviceSelectorFromPairingState($true)
    $devices = Await ([Windows.Devices.Enumeration.DeviceInformation]::FindAllAsync($selector)) `
                     ([Windows.Devices.Enumeration.DeviceInformationCollection])

    $matched = $devices | Where-Object { $_.Name -like "*$DeviceName*" }

    if (-not $matched) {
        Write-Host "No paired device found matching: $DeviceName"
        continue
    }

    foreach ($device in $matched) {
        Write-Host "Found: $($device.Name)"
        # Just fire UnpairAsync directly, no need to await the result
        $device.Pairing.UnpairAsync() | Out-Null
        Write-Host "Unpaired: $($device.Name)"
    }
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")