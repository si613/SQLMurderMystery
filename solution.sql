CREATE TABLE solution (
    [user] INT,
    value NVARCHAR(MAX)
);

GO

CREATE TRIGGER check_solution
ON solution
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF (SELECT [user] FROM inserted) = 1
    BEGIN
        DELETE FROM solution;

        DECLARE @message NVARCHAR(MAX);

        SELECT @message = 
            CASE 
                WHEN value = 'Jeremy Bowers' THEN
                    N'Congrats, you found the murderer! But wait, there''s more... If you think you''re up for a challenge, try querying the interview transcript of the murderer to find the real villain behind this crime. If you feel especially confident in your SQL skills, try to complete this final step with no more than 2 queries. Use this same INSERT statement with your new suspect to check your answer.'
                WHEN value = 'Miranda Priestly' THEN
                    N'Congrats, you found the brains behind the murder! Everyone in SQL City hails you as the greatest SQL detective of all time. Time to break out the champagne!'
                ELSE
                    N'That''s not the right person. Try again!'
            END
        FROM inserted;

        INSERT INTO solution VALUES (0, @message);
    END;
END;
