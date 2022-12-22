# Unicon Language Server Development

Pre-requisites: git, node, unicon, and VScode installed

# Description

This repo contains both the client and server... 

# Setup

### Important notes before we begin: <br />

> 1. .gitignore contains (among others) node_modules and out folders.<br />
> 2. node_modules will hold all dependencies required within the main directory and the client subfolder (you will notice a node_modules folder within each of these directories). <br />
> 3. out holds the transpiled code (Typescript --> Javascript) following build/watch script execution. <br />

### Acquiring dependencies: <br />

> 1. Move to the main directory `cd /path_to_repo/` <br />
> 2. Run command: `npm i` to install all dependencies required within the main directory. <br />

### Client setup: <br />

> 1. Move to the client subfolder `cd /path_to_repo/client/` <br />
> 2. Run command: `npm i` to install all dependencies required within the client subfolder. <br />
> 3. Change server command path in extension.ts: <br /> 
> > 3a) navigate to `/path_to_repo/client/src/extension.ts` file <br />
> > 3b) Edit line 24 (alter path within <...>, requires absolute path) --> <br />`const unicon: Executable = { command: '</ABSOLUTE_PATH_TO_REPO_DIRECTORY/server/unicon-lsp-server>', transport: transport };`

### Server setup: <br />

> 1. Move to the server folder: `cd /path_to_repo/server` <br />
> 2. Build server: `unicon unicon-lsp-server.icn`


# Run and Debug

We can test our server using the run and debug feature in VS code. 
<br />

### Getting Started

- You can find the "Run and Debug" option on the left navigation bar in VS code (see Figure 1).
<br />

Figure 1: Run and Debug Navigation Selection
![tempsnip](https://user-images.githubusercontent.com/80660221/201693239-13e15660-fec9-45fb-8945-217ed49a40dc.png)

<br /><br />

- After selecting the Run and Debug option, you should see a change in the panel to the right of the nav bar (see Figure 2).
<br />

Figure 2: Run and Debug Display
![tempsnip](https://user-images.githubusercontent.com/80660221/201693976-965d96cd-a63a-448b-9fe5-98bd26e73895.png)

<br />
<br />

- From the drop down menu indicated by the yellow arrow in Figure 2, select the "Launch Client" option then press F5 or the green button to the left to start. You will see a new separate "Extension Development Host" vscode window appear as indicated in Figure 3 (below). This serves as our playground for testing the unicon language server. 

<br />
Figure 3: New Extension Host Window After Launch 
<br />

![image](https://user-images.githubusercontent.com/80660221/201689356-331dcb3b-6153-477e-94d3-7b644cacc84a.png)

<br /><br />

### Working with the Extension Development Host

- After launching the extension development host using the steps above, you should see a vs code window similar to that in figure 3. <br />
- We have configured our client to trace the communication between server and client. This can be found in the package.json file in the root directory of our project (under "contributes" property). <br />
- To access the trace logs, we must have a vs code integrated terminal window open. The terminal appears at the bottom of your vs code window by default and is shown in figure 4 (below). If you do not see this window, use the shortcut:  ``ctrl + shift + ` `` or select the terminal menu as indicated in figure 4 (below). 

<br /> 

Figure 4: Integrated Terminal Window
![tempsnip](https://user-images.githubusercontent.com/80660221/201923571-fdae86a1-7de5-4206-821c-d704e3f98b79.png)

- To see any activity between client and server, we must activate our server through an activation event. This activation event can be found in the /package.json file under the "activationEvents" property. The current configuration uses the value "onLanguage:plaintext". This event type monitors the workspace for files opened with the plaintext (basically any file extension - .txt, .icn, .pl, etc.) extension and triggers the activation of our server.
- Assuming you have an empty workspace such that no files are "opened" in the workspace (right panel) of your vs code extension development host window, your extension development host window will look similar to that of figure 5 (below). Importantly, if your workspace is empty, your server will not be activated. Attempting to view the trace logs will be futile. 

<br />

Figure 5: Empty Workspace
![tempsnip](https://user-images.githubusercontent.com/80660221/201932122-f4634c5b-1724-4a5c-b6cb-7dcb7767ee31.png)

- To activate the server, simply open or create a file (preferrably with extension type .icn) within the extention development host window. Your workspace will no longer be empty and you should notice the "Unicon Language Server" option in the dropdown menu containing logs (illustrated in figure 5). See figure 6 below for visual representation.

<br />

Figure 6: Non-empty Workspace
![tempsnip](https://user-images.githubusercontent.com/80660221/201933614-f40a86a2-e720-41cc-9ddb-cd852dc792a3.png)



