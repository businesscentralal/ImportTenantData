codeunit 60322 "Import Project Data Scheduler"
{
    trigger OnRun()
    begin

    end;

    procedure ScheduleDataTransfer(var ImportProjectData: Record "Import Project Data"; SecondsDelay: Integer)
    begin
        with ImportProjectData do begin
            FindSet();
            repeat
                ScheduleDataTransferForTable(ImportProjectData, SecondsDelay);
            until Next() = 0;
        end;
        Message(DataImportScheduledMsg);
    end;

    local procedure ScheduleDataTransferForTable(var ImportProjectData: Record "Import Project Data"; SecondsDelay: Integer)
    begin
        ScheduleJobQueueEntry(Codeunit::"Import Project Data Transfer", ImportProjectData.RecordId(), SecondsDelay);
    end;

    local procedure ScheduleJobQueueEntry(CodeunitId: Integer; RelatedRecordId: RecordID; SecondsDelay: Integer)
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        if JobQueueEntryExists(CodeunitId, RelatedRecordId) then exit;
        JobQueueEntry.Init();
        JobQueueEntry."Earliest Start Date/Time" := CurrentDateTime() + (SecondsDelay * 1000);
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := CodeunitId;
        JobQueueEntry."Record ID to Process" := RelatedRecordId;
        JobQueueEntry."Run in User Session" := false;
        JobQueueEntry.Priority := 1000;
        CODEUNIT.Run(CODEUNIT::"Job Queue - Enqueue", JobQueueEntry);
    end;

    local procedure JobQueueEntryExists(CodeunitId: Integer; RelatedRecordId: RecordID): Boolean
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SetRange("Object ID to Run", CodeunitId);
        JobQueueEntry.SetRange("Record ID to Process", RelatedRecordId);
        exit(not JobQueueEntry.IsEmpty());
    end;

    var
        DataImportScheduledMsg: Label 'Data Import has been scheduled.';
}