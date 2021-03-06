page 60342 "SQL Connect Setup List"
{

    PageType = List;
    SourceTable = "SQL Connect Setup";
    Caption = 'SQL Connect Setup List';
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    CardPageId = "SQL Connect Setup Card";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Source ID"; "Source ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source ID field';
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field';
                }
            }
        }
    }

}
