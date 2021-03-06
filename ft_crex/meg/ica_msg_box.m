function varargout = ica_msg_box(varargin)
% ICA_MSG_BOX MATLAB code for ica_msg_box.fig
%      ICA_MSG_BOX by itself, creates a new ICA_MSG_BOX or raises the
%      existing singleton*.
%
%      H = ICA_MSG_BOX returns the handle to a new ICA_MSG_BOX or the handle to
%      the existing singleton*.
%
%      ICA_MSG_BOX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ICA_MSG_BOX.M with the given input arguments.
%
%      ICA_MSG_BOX('Property','Value',...) creates a new ICA_MSG_BOX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ica_msg_box_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ica_msg_box_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ica_msg_box

% Last Modified by GUIDE v2.5 03-Aug-2018 11:03:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ica_msg_box_OpeningFcn, ...
                   'gui_OutputFcn',  @ica_msg_box_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before ica_msg_box is made visible.
function ica_msg_box_OpeningFcn(hObject, eventdata, handles, varargin) %#ok
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ica_msg_box (see VARARGIN)

% Choose default command line output for ica_msg_box
handles.output = 1;

% Update handles structure
guidata(hObject, handles);

% Insert custom Title and Text if specified by the user
% Hint: when choosing keywords, be sure they are not easily confused 
% with existing figure properties.  See the output of set(figure) for
% a list of figure properties.
if(nargin > 3)
    for index = 1:2:(nargin-3)
        if nargin-3==index, break, end
        switch lower(varargin{index})
         case 'title'
          set(hObject, 'Name', varargin{index+1});
         case 'string'
          set(handles.text_warn, 'String', varargin{index+1});
        end
    end
end

% Determine the position of the dialog - centered on the callback figure
% if available, else, centered on the screen
FigPos=get(0,'DefaultFigurePosition');
OldUnits = get(hObject, 'Units');
set(hObject, 'Units', 'pixels');
OldPos = get(hObject,'Position');
FigWidth = OldPos(3);
FigHeight = OldPos(4);
if isempty(gcbf)
    ScreenUnits=get(0,'Units');
    set(0,'Units','pixels');
    ScreenSize=get(0,'ScreenSize');
    set(0,'Units',ScreenUnits);

    FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
    FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
else
    GCBFOldUnits = get(gcbf,'Units');
    set(gcbf,'Units','pixels');
    GCBFPos = get(gcbf,'Position');
    set(gcbf,'Units',GCBFOldUnits);
    FigPos(1:2) = [(GCBFPos(1) + GCBFPos(3) / 2) - FigWidth / 2, ...
                   (GCBFPos(2) + GCBFPos(4) / 2) - FigHeight / 2];
end
FigPos(3:4)=[FigWidth FigHeight];
set(hObject, 'Position', FigPos);
set(hObject, 'Units', OldUnits);

% Show a question icon from dialogicons.mat - variables questIconData
% and questIconMap
warnIconData = loadvar('dialogicons.mat', 'warnIconData');
warnIconMap = loadvar('dialogicons.mat', 'warnIconMap');
IconData = warnIconData;
warnIconMap(256,:) = get(handles.main, 'Color');
IconCMap = warnIconMap;

Img=image(IconData, 'Parent', handles.icon);
set(handles.main, 'Colormap', IconCMap);

set(handles.icon, ...
    'Visible', 'off', ...
    'YDir'   , 'reverse'       , ...
    'XLim'   , get(Img,'XData'), ...
    'YLim'   , get(Img,'YData')  ...
    );

% Make the GUI modal
set(handles.main,'WindowStyle','modal')

% UIWAIT makes ica_msg_box wait for user response (see UIRESUME)
uiwait(handles.main);

% --- Outputs from this function are returned to the command line.
function varargout = ica_msg_box_OutputFcn(hObject, eventdata, handles) %#ok
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% The figure can be deleted now
delete(handles.main);

% --- Executes on button press in but_redo.
function but_redo_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to but_redo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = 1;

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.main);

% --- Executes on button press in but_rem.
function but_rem_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to but_rem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = 0;

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.main);


% --- Executes when user attempts to close main.
function main_CloseRequestFcn(hObject, eventdata, handles) %#ok
% hObject    handle to main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end


% --- Executes on key press over main with no controls selected.
function main_KeyPressFcn(hObject, eventdata, handles) %#ok
% hObject    handle to main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check for "enter" or "escape"
if isequal(get(hObject,'CurrentKey'),'escape')
    % User said no by hitting escape
    handles.output = 'No';
    
    % Update handles structure
    guidata(hObject, handles);
    
    uiresume(handles.main);
end    
    
if isequal(get(hObject,'CurrentKey'),'return')
    uiresume(handles.main);
end    
