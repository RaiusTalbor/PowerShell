function Name($var)
{
    $var += "Hi!"
    return $var
}

$var2 = Name -var "Hi"

echo $var2