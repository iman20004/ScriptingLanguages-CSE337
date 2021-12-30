# Homework Assignment 5

## Learning Outcomes

After completion of this assignment, you should be able to:

- Write a light-weight web server using a domain-specific scripting language.

- Attain a basic understanding of HTTP request/response handling.


## Getting Started

To complete this homework assignment, you will need Ruby2 (preferably 2.6 or higher). You will also need the DSL Sinatra to write your web server. Install Sinatra using ruby gems. Follow the lecture notes for specific commands needed to install Sinatra.

Read the rest of the document carefully. This document describes everything that you will need to correctly implement the homework and submit the code for testing.

The first thing you need to do is download or clone this repository to your local system. Use the following command:

`$ git clone <ssh-link>`

After you clone, you will see a directory of the form *cise337-hw5-web-scripting-\<username\>*, where *username* is your GitHub username.

There is no starter code. You can reuse most of the code from homework 3. The *views* directory will hold the ERB files that you write. It currently has *home.erb*. You can add other ERB files to this directory as well.

You can also add additional ruby files to this repository if necessary. Be sure to push such files to the repository.

**At the top of treasure_hunt_web.rb, you will find hints to fill your full name, NetID, and SBU ID. Please fill them accurately**. This information will be used to collect your scores from GitHub. If you do not provide this information, your submission may not be graded. You should write the implementation and the tests needed to verify the correctness of your implementation.


## Grading

Your homework will be evaluated based the no. of features that you implement as described in the next section. We will start your server by running *treasure_hunt_web.rb* and connecting to the server URL from a browser. Your server is expected to work on all standard browsers, that is, Chrome, Firefox, Safari, and Internet Explorer.

## Problem Specification
Recall the treasure hunt game we developed in Homework 3. In this assignment we are going to develop a web-version of the game. To this end, we will write a web server to help players play the game from the browser. In the rest of the document, we will assume that the web server is running on *locahost* at port 4567, the default settings for Sinatra.

The rules of the game are same as described previously in homework 3. Everything we assumed for homework 3 apply here as well. Use the file *run_game.rb* from homework 3 to refresh your memory about how the game runs. You can reuse all code from homework 3 if necessary. To develop the web version, take inspiration from he *Narrator* and *Console* classes that was provided as starter code in homework 3.

In this homework, you are expected to do the following:

1. When a user opens a browser and connects to *https:localhost:4567* or *https:localhost:4567/*, the user should be directed to the game's home page. In this page you should have the following:

    * A message "Welcome to Treasure Hunt, it's <current-timestamp> at the server!"

    * A button with the label "Start Game". Clicking this button should bring the user *play_game* page.

2. In the *play_game* page, the user should see the following:

    * A message showing the cave room the player is currently in. For example, if the player is currently in room 5, the message should say "You are in room : 5".

    * A message showing the exits from the room in the cave. For example, if room 5 has exit rooms 2 and 7 in the cave layout, then you should display the message "Exits go to <2,7>".

    * Messages showing what the player sensed in adjacent rooms. These messages should appear on separate lines. For example, if the player is in room 5 and the adjacent rooms have bats in room2 and the guard in room7 then two messages on separate lines should be displayed -- "You hear a rustling sound nearby" and "You smell something terrible nearby".

    * A text field that takes an action (m)ove or s(hoot) as input from the user. The only valid actions a user can enter are 'm' or 's' (case matters). An invalid action entry should keep the user in the same page with an additional message "Invalid action! Try Again."

    * A text field that takes a destination room that the player intends to move or shoots an arrow to. This entry must be a room adjacent to the player's current room. An invalid entry should keep the user in the same page with an additional message "Invalid destination! Try Again."

    * A button labeled "Submit" that will perform the action that the user entered in the action field.

    * If the action is 'm' and the destination is valid, then player should remain on the same page with the updated information about the destination displayed. If the destination has bats then the player will be moved to a random new room and the page should display the information pertaining to the new room along with the message "Giant bats whisked you away to a new cavern". If the destination has the guard or a bottomless pit then the game will end. In this situation, the player should be directed to a new page with the message "Game over! You lost.". This page should have a button labeled "Restart Game". Clicking this button should take the user back to the game's home page, that is, the page that has the welcome message with the timestamp.

      If the action is 's', then the player should remain on the same page with a message "Your arrow missed" if the arrow shot missed the guard. Note the previous information on the page should also be displayed. If the player shoots and kills the guard, then the player should be directed to a new page with the message "Congratulations! You won ". This page should also have a button labeled "Restart Game".   

## Submitting Code to GitHub

You can submit code to your GitHub repository as many times as you want till the deadline. After the deadline, any code you try to submit will be rejected. To submit a file to the remote repository, you first need to add it to the local git repository in your system, that is, directory where you cloned the remote repository initially. Use following commands from your terminal:

`$ cd /path/to/cise337-hw5-web-scripting-<username>` (skip if you are already in this directory)

```
$ git add *.rb
$ git add views/
```

To submit your work to the remote GitHub repository, you will need to commit the file (with a message) and push the file to the repository. Use the following commands:

`$ git commit -m "<your-custom-message>"`

`$ git push`
