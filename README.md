The objective of this project was to develop a sound annotator with a GUI using the MATLAB GUI toolkit.
The annotator must allow the user to:
•	Import one wav music file and extract a track from it.
•	Import a short voice file and extract a track from it.
•	Play two sound tracks in full independently.
•	Allow users to merge the voice track and a selected section of the music track so that the voice annotates the music.
•	Play the new sound.
•	Save the new sound to disc in wav format.
On top of the minimum requirements the following extra features have been implemented:
•	Extra track controls to pause or stop tracks.
•	Progress bars for each track.
•	Graph displaying signal strength and time.
•	The capacity to flip either track so that it plays from back to front.
•	The capacity to alter the speed at which a track is played.
•	Looping tracks.
A user manual was also required and has been included in this document following the technical report.
For a demo of the completed project go to: https://northampton.mediaspace.kaltura.com/media/t/1_92jxtpev#
 
2. Analysis and Design
2.1 Extra Features
Track Controls
Each track has been provided a set of track controls within a UI panel to highlight which buttons correspond to which track. These controls allow users to independently play, pause, stop, loop, invert, and load each track. Track one also has a button to use the required save function.
Track controls were included as it is important for any interface to allow users to easily access any built in functionality.
Track Progress Bar
Each track has an allocated progress bar which provides a visual way of monitoring track progress as it plays. The progress bar comes with a label to inform the user how many seconds have passed in the track.
A track progress feature was seen as a necessary addition to make the system more user friendly and to better convey information about the playing and paused tracks.
Graphical Representation of Track
A set of axes for each track has been implemented to show the signal strength and track length. The axes are updated whenever the track is changed to display the new changes.
Plotting the track to an axes gives the user interesting information about the track and shows the effects of the signal on the sound. Using the axes also clearly displays whether a track is loaded or not by whether there is something plotted.
Looping Tracks
A loop track checkbox is included in the track controls for each track. The checkbox is a simple way for the user to indicate that they want the track to loop when it has finished playing and this is what the feature does.
The loop track feature was included as it brings extra functionality to the system that is situationally desirable and easy to implement.
Inverting Tracks
An invert track checkbox is included in the track controls for each track. The checkbox allows users to invert the current track by checking the box and invert it back by unchecking it.
The invert track feature was included as it as it allows the users an interesting extra track manipulation feature without overcomplicating the system.
Changing Play Speed
Controls to alter the play speed of the tracks have been included in their own UI divider. The slider alters the speed multiplier applied to the tracks. Once the speed multiplier has been changed the track restarts at the new speed. The reset button changes the speed back to its normal default value. The play speed modifier is not a permanent modifier applied to the file but is just for playback purposes.
The capacity to change play speed is included as an interesting playback manipulation feature.
