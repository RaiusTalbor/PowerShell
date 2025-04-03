$msg = "Hi!"
$targetPC = "sem205"

Invoke-Command -ComputerName $targetPC -ScriptBlock {
    param($message)
    msg * $message
} -ArgumentList $msg