**Disclaimer:** This code is not associated with the official Todoist app/team.

![](todoist_logo.png)


# LS-Todoist
This ruby script automatically creates tasks basewd on the list of files in a folder.

## Why?
Because you may have videos you want to watch, document you want to go through and having them in one single place is awesome.

## How?
Define an environment variable with your todoist security token: click [here](https://todoist.com/prefs/integrations) to find your token 
```bash
export todoist_token=<your token>
```

Run the script passing your path

```bash
./ls-toidst.rb -p ~/Desktop/VideosToWatch
```

The script will ask you to select one of your project:

```
Select your project: (Use arrow keys, press Enter to select)
‣ Inbox
  ⭐️ ls-todois
  📱 WWDC2018
  💻 RWDevConf
  🗽 Liberty
(Move up or down to reveal more choices)
```

Then you can decide the frequency of the tasks:

```
How many days between each task? (1)
```

A short recap to be sure that everything is fine...

```
+---+---------------------------------------------------------------+------------+
|   | Task                                                          | Date       |
+---+---------------------------------------------------------------+------------+
| 1 | 401_sd_whats_new_in_swift.mp4 (1/5)                           | 2018/07/28 |
| 2 | 403_sd_whats_new_in_testing.mp4 (2/5)                         | 2018/07/29 |
| 3 | 402_sd_getting_the_most_out_of_playgrounds_in_xcode.mp4 (3/5) | 2018/07/30 |
| 4 | 404_sd_new_localization_workflows_in_xcode_10.mp4 (4/5)       | 2018/07/31 |
| 5 | 405_sd_measuring_performance_using_logging.mp4 (5/5)          | 2018/08/01 |
+---+---------------------------------------------------------------+------------+
Create the tasks? (Y/n)
``` 


and go.


```
Create the tasks? Yes
Due to Todoist limitations, a new task is created every 5 seconds

1 of 4 - Created task 2746495621
2 of 4 - Created task 2746495704
3 of 4 - Created task 2746495842
4 of 4 - Created task 2746495905
```
