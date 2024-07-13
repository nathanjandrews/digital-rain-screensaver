#  Digital Rain Screen Saver for MacOS

This is a custom MacOS screensaver that displays the "digital rain" from the the movie "The Matrix":

![digital-rain](https://github.com/user-attachments/assets/809386d5-be80-486e-9872-2aa6876a41a3)

## Customization

![screensaver_options](https://github.com/user-attachments/assets/cdd2533d-5740-432a-96d4-2c21987dd255)

You can customize the following features of the screensaver:

- *Seed String*: The set of characters that is used to randomly select
  characters to the columns of text.

- *Font Size*: The size of characters in a column. This option also
  affects the number of columns of text. The larger the font, the
  fewer the columns.
  
- *Text Color*: The color of the text in the columns

- *Highlight Text Color*: About 1-in-5 columns are "highlight columns".
  You can change the color of these highlight columns independently of
  the other columns
  
- *Background Color*: The color of the background behind the text columns.

## Installation

Release builds are not signed or notarized. That would require enrollment into the
paid [Apple Developer Program](https://developer.apple.com/support/enrollment),
which is $99 that I do not want to spend. Nonetheless, you can still install a
release build by either installing the unsigned build or building from source:

### Installing an Unsigned Build

1. Download a [release build](https://github.com/nathanjandrews/digital-rain-screensaver/releases)

2. Unzip the downloaded file

3. Open `Digital Rain.saver` and follow the prompted installation instructions.
   You will be taken to the Screen Saver menu of System Settings.
   
4. Select the screen saver (it should be in the "Other" section of the listed
   screen savers). You will be warned that Apple cannot check the screen saver
   for malicious software. Choose "OK", and then select a different screen
   saver to stop the warning from continuously reappearing.

   <details>
      <summary>View Image</summary>
      
      ![malicious_software_warning](https://github.com/user-attachments/assets/e1ebb98b-673f-4f1a-a3d6-569323f6c47e)
   </details>

5. Go to the Privacy & Security menu in System Settings, scroll down to Security,
   and click "Open Anyway" under the message about `Digital Rain.saver`.

   <details>
      <summary>View Image</summary>

      ![open_anyway](https://github.com/user-attachments/assets/873b045c-f382-4226-b4a6-0fecbe5d4b94)
   </details>
   
6. Go back to the Screen Saver settings, select the screen saver again, and
   select "OK", which should now be available.

   <details>
      <summary>View Image</summary>

      ![malicious_software_warning_with_ok](https://github.com/user-attachments/assets/1713d6e0-8841-447b-9d6c-4c43741a3392)
   </details>
   
7. That's it!

### Building from Source

1. [Download Xcode](https://developer.apple.com/download/applications/) if you do
   not already have it installed.

2. Clone this repo to your machine are download the source code from a
   [release build](https://github.com/nathanjandrews/digital-rain-screensaver/releases).

3. Open the project in Xcode.

4. Build the project. To do this, in the menu bar, select `Product -> Build For -> Profiling`.
   This will create a release build for the project with optimizations.
   
5. Locate the output file:
    1. In the menu bar of the Xcode project, select `Product -> Show Build Folder in Finder`.
    2. This will open the `Build` folder in a Finder window. In this folder, open
       the `Products` folder, and then the `Release` folder. In this folder there
       will be the `Digital Rain.saver` file.
   
7. Install the screen saver by either:
    - Opening the `Digital Rain.saver` file to install it in System Settings OR
    - Manually copying the `Digital Rain.saver` file to `~/Library/Screen Savers/`
    
8. That's it!

## Acknowledgments

I would be remiss not to include a link to [this article](https://zsmb.co/building-a-macos-screen-saver-in-kotlin/#preview-problems)
by [@zsmb13](https://github.com/zsmb13). This article gave me a modern blueprint
to build a custom screensaver as the resources and discussions surrounding the
MacOS screen saver APIs are dated. If you want to build your own screen saver
(and even write it in Kotlin), then I would strongly recommend reading zsmb's
article and looking through the [corresponding repo](https://github.com/zsmb13/KotlinLogo-ScreenSaver).
