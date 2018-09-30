function varargout = stack_viewer(varargin)
% STACK_VIEWER MATLAB code for stack_viewer.fig
%      STACK_VIEWER, by itself, creates a new STACK_VIEWER or raises the existing
%      singleton*.
%
%      H = STACK_VIEWER returns the handle to a new STACK_VIEWER or the handle to
%      the existing singleton*.
%
%      STACK_VIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STACK_VIEWER.M with the given input arguments.
%
%      STACK_VIEWER('Property','Value',...) creates a new STACK_VIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stack_viewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stack_viewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stack_viewer

% Last Modified by GUIDE v2.5 17-Apr-2018 10:06:48


% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stack_viewer_OpeningFcn, ...
                   'gui_OutputFcn',  @stack_viewer_OutputFcn, ...
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


% --- Executes just before stack_viewer is made visible.
function stack_viewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stack_viewer (see VARARGIN)

% Choose default command line output for stack_viewer
handles.output = hObject;

handles.data.image = varargin{1};

if ischar(handles.data.image)
    filename = handles.data.image;
    info = imfinfo(filename);
    handles.data.image = zeros(info(1).Height,info(1).Width,length(info),'uint16');
    for i = 1:length(info)
        handles.data.image(:,:,i) = imread(filename,i);
    end
end

if length(varargin) > 1 && ~isempty(varargin{2})
    handles.data.nuc_locs_image_coord = varargin{2};
    if length(varargin) > 2 && ~isempty(varargin{3})
        handles.data.fluor_vals = varargin{3};
    else
        for i = 1:length(handles.data.nuc_locs_image_coord)
            handles.data.fluor_vals{i} = Inf*ones(size(handles.data.nuc_locs_image_coord{i},1),1);
        end
    end
else
    handles.data.nuc_locs_image_coord = [];
    handles.data.fluor_vals = [];
end

handles.data.fluor_thresh = 0;

if length(varargin) > 3 && ~isempty(varargin{4})
    handles.data.slice_ind = varargin{4};
else
    handles.data.slice_ind = 1;
end 

if length(varargin) > 4 && ~isempty(varargin{5})
    handles.data.image_g = varargin{5};
    set(handles.overlay_green_check,'enable','on')
    if ischar(handles.data.image_g)
        filename = handles.data.image_g;
        info = imfinfo(filename);
        handles.data.image_g = zeros(info(1).Height,info(1).Width,length(info),'uint16');
        for i = 1:length(info)
            handles.data.image_g(:,:,i) = imread(filename,i);
        end
    end
end
if length(varargin) > 5 && ~isempty(varargin{6})
    handles.data.parent_handles = varargin{6};
    handles.data.parent_hObject = varargin{7};
end

handles.data.proj_offset = 7;

handles.data.proj_top = max(handles.data.slice_ind-handles.data.proj_offset,1);
handles.data.slice_max = size(handles.data.image,3);
handles.data.proj_bottom = min(handles.data.slice_max,handles.data.slice_ind+handles.data.proj_offset);
set(handles.proj_top,'String',num2str(handles.data.proj_top));
set(handles.proj_bottom,'String',num2str(handles.data.proj_bottom));

maxval = 12500;
linvals = linspace(0,1,maxval)';
handles.data.red_colormap = ...
    horzcat(linvals, zeros(size(linvals)) , zeros(size(linvals)));

handles.data.selected_cell_pos = [];
handles.data.clim_min = 0; 
handles.data.clim_max = 1000;
set(handles.clim_max_slider,'Value',handles.data.clim_max)

set(handles.z_slice_slider,'Min',1)
set(handles.z_slice_slider,'Max',handles.data.slice_max)
set(handles.z_slice_slider,'Value',handles.data.slice_ind)
set(handles.z_slice_slider,'SliderStep',[1/(handles.data.slice_max - 1) 1])

handles.data.show_green = 0;

handles.data.scatter_shapes = {'o','x'};
handles.data.scatter_colors = {'w','g'};
guidata(hObject, handles);

handles.data.init = 1;
guidata(hObject, handles);
draw_all(handles)
handles.data.init = 0;
guidata(hObject, handles);



% Update handles structure


% UIWAIT makes stack_viewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = stack_viewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.output;
% delete(handles.figure1)

function draw_all(handles)
set(handles.selected_cell_text,'String',mat2str(round(handles.data.selected_cell_pos)))
draw_slice(handles)
draw_proj(handles)


function draw_slice(handles)

axes(handles.slice_axes)
if ~handles.data.init
    xlims = get(handles.slice_axes,'xlim');
    ylims = get(handles.slice_axes,'ylim');
end
% plot slice
this_image = handles.data.image(:,:,handles.data.slice_ind);
if handles.data.show_green
    this_image_g = handles.data.image_g(:,:,handles.data.slice_ind);
    rg_image = imfuse(this_image,this_image_g,'falsecolor','ColorChannels',[1 2 0]);
    imagesc(rg_image)
    hold on
else

    imagesc(this_image)
    hold on
end
    colormap(handles.data.red_colormap)
    caxis([handles.data.clim_min handles.data.clim_max])
    
    % plot cells
    
    for i = 1:length(handles.data.nuc_locs_image_coord)
        slice_dist = abs(handles.data.nuc_locs_image_coord{i}(:,3) - handles.data.slice_ind);
        these_cell_i = slice_dist < 6 & handles.data.fluor_vals{i} > handles.data.fluor_thresh;
        handles.data.slice_cell_i = these_cell_i;
        these_cell_coord = handles.data.nuc_locs_image_coord{i}(these_cell_i,:);
        scatter(these_cell_coord(:,1), these_cell_coord(:,2),...
            40,...
            handles.data.scatter_colors{i},handles.data.scatter_shapes{i});

        if ~isempty(handles.data.selected_cell_pos)
            scatter(handles.data.selected_cell_pos(1),handles.data.selected_cell_pos(2),'gx')
        end
    end
    
% end
set(handles.z_slice_text,'String',num2str(handles.data.slice_ind))





hold off
if ~handles.data.init
    set(handles.slice_axes,'xlim',xlims)
    set(handles.slice_axes,'ylim',ylims)
end

guidata(handles.slice_axes,handles)
draw_proj(handles)


function draw_proj(handles)

handles.data.proj_offset = 7;

handles.data.proj_top = max(handles.data.slice_ind-handles.data.proj_offset,1);
handles.data.slice_max = size(handles.data.image,3);
handles.data.proj_bottom = min(handles.data.slice_max,handles.data.slice_ind+handles.data.proj_offset);
set(handles.proj_top,'String',num2str(handles.data.proj_top));
set(handles.proj_bottom,'String',num2str(handles.data.proj_bottom));

% handles.data.proj_top = str2double(get(handles.proj_top,'String'));
% if handles.data.proj_top < 1
%     handles.data.proj_top = 1;
% end
% 
% handles.data.proj_bottom = str2double(get(handles.proj_bottom,'String'));
% if handles.data.proj_bottom > handles.data.slice_max
%     handles.data.proj_bottom = handles.data.slice_max;
% end

axes(handles.maxproj_axes)
if ~handles.data.init
    xlims = get(handles.maxproj_axes,'xlim');
    ylims = get(handles.maxproj_axes,'ylim');
else
    xlim([1 256])
    ylim([1 256])
end

% plot proj
imagesc(max(...
    handles.data.image(:,:,handles.data.proj_top:handles.data.proj_bottom),[],3));
hold on

caxis([handles.data.clim_min handles.data.clim_max])
colormap(handles.data.red_colormap)

% plot cells
for i = 1:length(handles.data.nuc_locs_image_coord)
    these_cell_i = handles.data.nuc_locs_image_coord{i}(:,3) < (handles.data.proj_bottom + 5) & ...
        handles.data.nuc_locs_image_coord{i}(:,3) > (handles.data.proj_top - 5);
    these_cell_i = these_cell_i & handles.data.fluor_vals{i} > handles.data.fluor_thresh;
    handles.data.proj_cell_i = these_cell_i;
    these_cell_coord = handles.data.nuc_locs_image_coord{i}(these_cell_i,:);
    scatter(these_cell_coord(:,1), these_cell_coord(:,2),...
        40,...
        handles.data.scatter_colors{i},handles.data.scatter_shapes{i});

    if ~isempty(handles.data.selected_cell_pos)
        scatter(handles.data.selected_cell_pos(1),handles.data.selected_cell_pos(2),'gx')
    end
end

hold off
if ~handles.data.init
    set(handles.maxproj_axes,'xlim',xlims)
    set(handles.maxproj_axes,'ylim',ylims)
else
    xlim([1 256])
    ylim([1 256])
end
guidata(handles.maxproj_axes,handles)

% --- Executes on button press in stack_down.
function stack_down_Callback(hObject, eventdata, handles)
% hObject    handle to stack_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.data.slice_ind = handles.data.slice_ind + 1;
if handles.data.slice_ind > handles.data.slice_max
    handles.data.slice_ind = 1;
end
guidata(hObject,handles)
draw_slice(handles)

% --- Executes on button press in stack_up.
function stack_up_Callback(hObject, eventdata, handles)
% hObject    handle to stack_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.data.slice_ind = handles.data.slice_ind - 1;
if handles.data.slice_ind < 1
    handles.data.slice_ind = handles.data.slice_max;
end
guidata(hObject,handles)
draw_slice(handles)


function proj_top_Callback(hObject, eventdata, handles)
% hObject    handle to proj_top (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of proj_top as text
%        str2double(get(hObject,'String')) returns contents of proj_top as a double
draw_proj(handles)

% --- Executes during object creation, after setting all properties.
function proj_top_CreateFcn(hObject, eventdata, handles)
% hObject    handle to proj_top (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function proj_bottom_Callback(hObject, eventdata, handles)
% hObject    handle to proj_bottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of proj_bottom as text
%        str2double(get(hObject,'String')) returns contents of proj_bottom as a double
draw_proj(handles)

% --- Executes during object creation, after setting all properties.
function proj_bottom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to proj_bottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in select_cell_slice.
function select_cell_slice_Callback(hObject, eventdata, handles)
% hObject    handle to select_cell_slice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in select_cell_proj.
function select_cell_proj_Callback(hObject, eventdata, handles)
% hObject    handle to select_cell_proj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.maxproj_axes)
[col row] = ginput(1);

these_cells = handles.data.nuc_locs_image_coord{1}(handles.data.proj_cell_i,1:2);
offsets = bsxfun(@minus,these_cells,[col row]);

[targ_error, index] = min(sqrt(sum(offsets.^2,2)));

cell_inds = find(handles.data.proj_cell_i);
index = cell_inds(index);
% handles.data.fluor_val = fluor_vals(index);
handles.data.selected_cell_index_full = index;
handles.data.selected_cell_pos = handles.data.nuc_locs_image_coord{1}(index,:);

handles.data.parent_handles.data.stack_viewer_output.selected_cell_index_full = handles.data.selected_cell_index_full;
handles.data.parent_handles.data.stack_viewer_output.selected_cell_pos = handles.data.selected_cell_pos;
handles.data.parent_handles.data.stack_viewer_output.fluor_thresh = str2double(get(handles.fluor_thresh,'String'));

guidata(handles.data.parent_hObject,handles.data.parent_handles)

guidata(hObject,handles)
draw_all(handles)


% --- Executes on slider movement.
function z_slice_slider_Callback(hObject, eventdata, handles)
% hObject    handle to z_slice_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.data.slice_ind = round(get(hObject,'Value'));
guidata(hObject,handles)
draw_all(handles)

% --- Executes during object creation, after setting all properties.
function z_slice_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_slice_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function clim_min_slider_Callback(hObject, eventdata, handles)
% hObject    handle to clim_min_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.data.clim_min = get(hObject,'Value');
set(handles.clim_max_slider,'min',handles.data.clim_min)
guidata(hObject,handles)
draw_all(handles)


% --- Executes during object creation, after setting all properties.
function clim_min_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clim_min_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function proj_axes_clim_slider_Callback(hObject, eventdata, handles)
% hObject    handle to proj_axes_clim_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function proj_axes_clim_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to proj_axes_clim_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in link_axes_check.
function link_axes_check_Callback(hObject, eventdata, handles)
% hObject    handle to link_axes_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of link_axes_check

if get(hObject,'Value')
    option = 'xy';
else
    option = 'off';
end

linkaxes([handles.slice_axes handles.maxproj_axes],option)


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on slider movement.
function clim_max_slider_Callback(hObject, eventdata, handles)
% hObject    handle to clim_max_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.data.clim_max = get(hObject,'Value');
set(handles.clim_min_slider,'max',handles.data.clim_max)

guidata(hObject,handles)

draw_all(handles)

% --- Executes during object creation, after setting all properties.
function clim_max_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clim_max_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function clim_max_val_Callback(hObject, eventdata, handles)
% hObject    handle to clim_max_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of clim_max_val as text
%        str2double(get(hObject,'String')) returns contents of clim_max_val as a double

new_max = str2double(get(hObject,'String'));
set(handles.clim_max_slider,'max',new_max)


% --- Executes during object creation, after setting all properties.
function clim_max_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clim_max_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function clim_min_val_Callback(hObject, eventdata, handles)
% hObject    handle to clim_min_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of clim_min_val as text
%        str2double(get(hObject,'String')) returns contents of clim_min_val as a double

new_min = str2double(get(hObject,'String'));
set(handles.clim_max_slider,'min',new_min)

% --- Executes during object creation, after setting all properties.
function clim_min_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clim_min_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in overlay_green_check.
function overlay_green_check_Callback(hObject, eventdata, handles)
% hObject    handle to overlay_green_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of overlay_green_check

handles.data.show_green = get(hObject,'Value');
guidata(hObject,handles)
draw_all(handles)



function fluor_thresh_Callback(hObject, eventdata, handles)
% hObject    handle to fluor_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fluor_thresh as text
%        str2double(get(hObject,'String')) returns contents of fluor_thresh as a double

handles.data.fluor_thresh = str2double(get(hObject,'String'));
guidata(hObject,handles)
draw_all(handles)


% --- Executes during object creation, after setting all properties.
function fluor_thresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fluor_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

delete(hObject)


