Process the next N items from the inbox. Default N=1 if not specified as an argument.

## Steps

1. **Check in-progress.** List files in `in-progress/` (excluding `.gitkeep`). If any exist, warn: "Found item(s) already in-progress — may indicate a previous run did not complete. Inspect before continuing." Then stop unless the user explicitly says to continue.

2. **List inbox.** List all `.md` files in `inbox/` (excluding `.gitkeep`), sorted lexicographically ascending. The first file is next (oldest = FIFO).

3. **If inbox is empty,** report "Inbox is empty — nothing to process." and stop.

4. **Pick up to N items** from the sorted list.

5. **For each item** (process one at a time, sequentially):

   a. **Move to in-progress**: copy the file to `in-progress/`, delete from `inbox/`.

   b. **Read the file.** Extract the `## Task Prompt` section. If it is missing or empty, append a `## Result` noting "Skipped — Task Prompt section is missing or empty." and move directly to `done/`.

   c. **Execute the Task Prompt** as literal instructions. Carry out the work described. This may involve editing files, running code, calling tools, researching, etc.

   d. **Append result.** Add the following section to the end of the file in `in-progress/`:
      ```markdown
      ## Result
      - **Completed:** {{current datetime}}
      - **Summary:** {{1-3 sentences describing what was done, any caveats, links to key outputs}}
      ```

   e. **Move to done**: copy the file to `done/`, delete from `in-progress/`.

6. **Final report.** After processing all N items (or fewer if inbox had less), print a summary:
   - How many items were processed
   - Title and filename of each
   - One-line result per item
   - How many items remain in inbox
