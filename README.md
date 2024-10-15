# github-user-activity 

https://roadmap.sh/projects/github-user-activity

Use GitHub API to fetch user activity and display it in the terminal.


The fetch_github_activity function uses Ruby's Net::HTTP to make a request to the GitHub API.

The format_activity function formats each event into a human-readable string.

The display_activity function prints the formatted activities.

We check for the correct number of command-line arguments and handle errors appropriately.

To use this script:

Save it as github-activity.rb.
Make it executable: chmod +x github-activity.rb
Run it from the command line: ./github-activity.rb <username>