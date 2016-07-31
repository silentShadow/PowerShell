$source = @"
public class pawobject 
{
    public string Description { get; set;}
    public string Name { get; set;}
    public int Number { get; set;}
}
"@

Add-Type $source -Language CSharpVersion3  

$myobject = New-Object -TypeName pawobject -Property @{
      Name = "myobject3";
      Number = 200;
      Description = "More complicated again"
      }
