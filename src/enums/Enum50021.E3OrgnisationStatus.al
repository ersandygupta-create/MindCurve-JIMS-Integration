enum 50021 "E3 Allocation Status"
{
    Extensible = true;
    Caption = 'Allocation Status';

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; "Fully Allocate")
    {
        Caption = 'Fully Allocate';
    }
    value(2; "Partial Allocate")
    {
        Caption = 'Partial Allocate';
    }
}