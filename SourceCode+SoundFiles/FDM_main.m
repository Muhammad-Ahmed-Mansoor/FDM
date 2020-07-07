%function FMD_main
%Inputs:----------------
%   NONE
%Outputs:---------------
%   NONE
%Notes:-----------------
%   This is the main function of the project. It ties everything together,
%   and provides the GUI as well. Since all parts of this function are
%   tightly integrated with eachother and the GUI, thus all parts have been
%   kept in the same file to avoid long parameter lists. However,
%   considerable modularity has been maintained by using sub-functions
%   inside the main function. Among these 'perform_calculations()' handles
%   the calculations. Most of the remaining sub-functions are call-backs
%   for the uicontrols.
function FDM_main

%handle for the main parent figure
hmain_figure=figure('name','FDM Project','position',[200 200 800 600],...
                    'menubar','none','toolbar','none');


%gui elements for intro screen---------------------------------------------

%panel with introductory text
hintro_panel=uipanel('units','pixels','parent',hmain_figure,'position',[20 200 360 90],...
                   'title','Introduction','backgroundcolor',get(hmain_figure,'color'));
%scaling the fontsize
set(hintro_panel,'fontsize',1.5*get(hintro_panel,'fontsize'));

%textbox inside the intro panel
hintro_text=uicontrol('parent',hintro_panel,'style','text',...
                    'position',[5 5 350 60],'backgroundcolor',get(hmain_figure,'color'),...
                    'horizontalalignment','left',...
                    'string',strcat('This program is an interactive demonstration of Frequency '...
                    ,' Division Modulation(FDM). Four audio signals are passed through the '...
                    ,' various stages of the FDM process. Each stage can be viewed in both '...
                    ,' time and frequency domains as well as heard in audio form.'));

%panel with the name of team members                
hteam_panel=uipanel('units','pixels','parent',hmain_figure,'position',[20 20 180 160],...
                    'title','The Team','backgroundcolor',get(hmain_figure,'color'));
%scaling the fontsize
set(hteam_panel,'fontsize',1.5*get(hteam_panel,'fontsize'));

%making a string with the names of team members
team_names=sprintf('%s\n%s\n%s\n%s\n%s','Muhammad Ahmed Mansoor',...
                   'Ali Abdul Rahman','Aamna Arshad','Faisal Siddique',...
                   'Malik Aqib Zahoor Awan');

%textbox inside the team_panel
hteam_text=uicontrol('parent',hteam_panel,'style','text',...
                    'position',[5 5 170 130],'backgroundcolor',get(hmain_figure,'color'),...
                    'horizontalalignment','left',...
                    'string',team_names);

%the button to start the main program         
hstart_but=uicontrol('parent',hmain_figure,'style','pushbutton','position',[330 20 50 23],...
                    'string','Start','callback',{@next_but_callback});             
                
%gui elements for main program screens---------------------------------------------

%panel that shows the text above each screen
htext_panel=uipanel('units','pixels','parent',hmain_figure,'position',[100 530 650 60],...
                   'title','Heading','backgroundcolor',get(hmain_figure,'color'));
%scaling the fontsize
set(htext_panel,'fontsize',1.5*get(htext_panel,'fontsize'));
%the textbox containing the text            
hexp_text=uicontrol('parent',htext_panel,'style','text',...
                    'position',[5 5 640 30],'backgroundcolor',get(hmain_figure,'color'),...
                    'horizontalalignment','left',...
                    'string','This is just some sample text.');

%the right side popup menu
hpop_1=uicontrol('parent',hmain_figure,'style','popupmenu','position',[100 485 150 30],...
                    'string',{'select 1','select 1','select 3'},'callback',{@popup_callback});

%the second popup menu
hpop_2=uicontrol('parent',hmain_figure,'style','popupmenu','position',[260 485 150 30],...
                    'string',{'select 1','select 1','select 3'},'callback',{@popup_callback});
 
%the top play/pause button
haudio_1=uicontrol('parent',hmain_figure,'style','pushbutton','position',[650 490 100 23],...
                    'string','Play Audio','callback',{@audio_callback});

%the bottom play/pause button
haudio_2=uicontrol('parent',hmain_figure,'style','pushbutton','position',[650 250 100 23],...
                    'string','Play Audio','callback',{@audio_callback});
            
%the top axes
haxes_1=axes('unit','pixel','position',[100 315 650 165],'box','on');

%the bottom axes
haxes_2=axes('unit','pixel','position',[100 75 650 165],'box','on');

%the next button 
hnext_but=uicontrol('parent',hmain_figure,'style','pushbutton','position',[700 25 50 23],...
                    'string','Next','callback',{@next_but_callback});

%the back button                
hback_but=uicontrol('parent',hmain_figure,'style','pushbutton','position',[100 25 50 23],...
                    'string','Back','callback',{@back_but_callback});

%gui elements for endscreen------------------------------------------------

%the panel that contains the saving instructions, text space for path and
%the save button
hsave_panel=uipanel('units','pixels','parent',hmain_figure,'position',[20 100 360 190],...
                   'title','Save Audio','backgroundcolor',get(hmain_figure,'color'));
               set(hsave_panel,'fontsize',1.5*get(hsave_panel,'fontsize'));

%the saving instructions texbox
hsave_text=uicontrol('parent',hsave_panel,'style','text',...
                    'position',[5 105 350 60],'backgroundcolor',get(hmain_figure,'color'),...
                    'horizontalalignment','left',...
                    'string',strcat('All the audio signals produced during',...
                    ' the preceeding process can be saved. Enter the path',...
                    ' to an existing directory and press save. To save in the current',...
                    ' directory, leave the path blank and press save.'));

%the box to enter the path                 
hsave_edit=uicontrol('parent',hsave_panel,'style','edit',...  
                      'position',[55 95 250 20]');

%the save button
hsave_but=uicontrol('parent',hsave_panel,'style','pushbutton',...  
                      'position',[300 10 50 23]','string','Save','callback',{@save_but_callback});

%the exit button                  
hexit_but=uicontrol('parent',hmain_figure,'style','pushbutton','position',[330 20 50 23],...
                    'string','Exit','callback','close');
                
%the back button for the end-screen
hend_back_but=uicontrol('parent',hmain_figure,'style','pushbutton','position',[20 20 50 23],...
                    'string','Back','callback',{@back_but_callback});
       
%Initializing variables for the signals to use globally through all sub-
%functions
fs=0;                       %sampling frequency
t=[];                       %time axis
f=[];                       %frequency axis
sig={};                     %the signals
sig_fil={};                 %the filtered signals
sig_mod={};                 %the modulated signals
sig_trans=[];               %the transmission signal
sig_mod_rec={};             %the recovered modulated signals
sig_demod={};               %the demodulated signals
sig_final={};               %the final signals

%preparing mechanisms for using and displaying filters
fil_ir={{},{},{},{}};   %the filter impulse-responses
%the filter-technology list
fil_tech={'butterworth','elliptic','leastsquares','window'};

%initializing audioplayers globally
audio_1=0;
audio_2=0;
                
%setting the initial screen number and displaying the GUI
current_screen=1;
previous_screen=1;
display_current_screen();

%defining a check to prevent illegal 'next clicks' while calculating
navigation_free=1;

%sub functions start-------------------------------------------------------

    %this function is responsible for updating the graphics as well as the
    %data for the current screen. It reads the current and previous screen
    %numbers and decides which ui elements to hide and which to show. As
    %there is no numerical pattern according to which the contents of each
    %page may be displayed, we have used a switch-case based approach.
    function display_current_screen()
        
        switch current_screen   %deciding contents on the basis of current screen number
            
            case 1%------------------------------------------------------------------------------------------
                
                %clear any graphs present in the axes. Added to remove some
                %artifacts that were seen if we navigate back using 'back'
                %button                
                cla(haxes_1);
                cla(haxes_2);
                
                %set the units to pixels so exact ui sizes can be dictated
                set([hmain_figure,htext_panel,hexp_text,hpop_1,hpop_2,haudio_1,...
                 haudio_2,haxes_1,haxes_2,hnext_but,hback_but],'units','pixels');
                
                %find the center of the screen
                screen_size=get(0,'screensize'); %total screen size
                x_dist=0.5*(screen_size(3)-400); %center x coordinate
                y_dist=0.5*(screen_size(4)-300); %center y coordinate
                %set the position of figure as center of screen
                set(hmain_figure,'resize','off','position',[x_dist y_dist 400 300]);
                
                %hide unnecessary uicontrols
                set([htext_panel,hexp_text,hpop_1,hpop_2,haudio_1,...
                 haudio_2,haxes_1,haxes_2,hnext_but,hback_but,hsave_panel,...
                 hsave_text,hsave_edit,hsave_but,hexit_but,hend_back_but],'visible','off');
                
                %show the relevant uicontrols
                set([hintro_panel,hintro_text,hteam_panel,hteam_text,hstart_but],...
                    'visible','on');
             
            case 2%------------------------------------------------------------------------------------------
                
                %clear any graphs present in the axes. Added to remove some
                %artifacts that were seen if we navigate back using 'back'
                %button   
                cla(haxes_1);
                cla(haxes_2);
                
                %things to do if we land here from page 1
                if previous_screen==1
                    %perform calculations
                    perform_calculations();
                    %making un-needed gui elements invisible
                    set([hintro_panel,hintro_text,hteam_panel,hteam_text,hstart_but],...
                        'visible','off');

                    %as the parent figure is resizing if coming from 1, 
                    %all sizes must be reset
                    screen_size=get(0,'screensize');
                    x_dist=0.5*(screen_size(3)-800);
                    y_dist=0.5*(screen_size(4)-625);
                    set(hmain_figure,'resize','on','position',[x_dist y_dist 800 625]);
                    set(htext_panel,'position',[100 555 650 60]);
                    set(hexp_text,'position',[5 5 640 30]);
                    set(hpop_1,'position',[100 520 150 30]);
                    set(hpop_2,'position',[260 520 150 30]);
                    set(haudio_1,'position',[650 525 100 23]);
                    set(haudio_2,'position',[650 270 100 23]);
                    set(haxes_1,'position',[100 335 650 165]);
                    set(haxes_2,'position',[100 95 650 165]);
                    set(hnext_but,'position',[700 25 50 23]);
                    set(hback_but,'position',[100 25 50 23]);

                    %set units to normalized to allow bug-free resizing
                    set([hmain_figure,htext_panel,hexp_text,hpop_1,hpop_2,haudio_1,...
                     haudio_2,haxes_1,haxes_2,hnext_but,hback_but],'units','normalized');

                    %setting the required gui elements visible
                    set([htext_panel,hexp_text,hpop_1,haudio_1,...
                     haxes_1,haxes_2,hnext_but,hback_but],'visible','on');
                
                %things to do if we land here from page 3
                elseif previous_screen==3
                    %making required gui elements visible
                    set(haudio_1,'visible','on');
                end
             
                %setting the heading and explanaion text
                set(htext_panel,'title','1. Original Signals');
                set(hexp_text,'string',strcat('Four audio recordings have been taken',...
                    ' as the original signals on which FDM shall be demonstrated.'));

                %setting the selection list of popup menu 1
                set(hpop_1,'value',1,'string',{'Signal 1','Signal 2','Signal 3','Signal 4'});
                
                %updating graphs
                update_graphs();  
                
                             
                
            case 3%------------------------------------------------------------------------------------------
                
                %clear any graphs present in the axes. Added to remove some
                %artifacts that were seen if we navigate back using 'back'
                %button   
                cla(haxes_1);
                cla(haxes_2);
                %making unneeded gui elements invisible
                set(haudio_1,'visible','off');
                
                %setting the heading and explanaion text
                set(htext_panel,'title','2. Low Pass Filter');
                set(hexp_text,'string',strcat('The four signals are passed through a',...
                    ' 3kHz lowpass filter. This not only makes them band-limited,',...
                    ' allowing for easier FDM, but also removes high frequency noise.',...
                    ' The desired type of lowpass filter can be chosen below.'));

                %setting the selection list of popup menu 1
                set(hpop_1,'value',1,'string',{'IIR Butterworth','IIR Elliptic','FIR Least-Squares','FIR Window (Rectangular)'});
                
                %managing the axes labels and updating graphs
                update_graphs(); 
                
                
                
            case 4%------------------------------------------------------------------------------------------
                
                if previous_screen==3
                    %perform calculations
                    perform_calculations;
                    %making required gui elements visible
                    set(haudio_1,'visible','on');
                end
                
                %clear any graphs present in the axes. Added to remove some
                %artifacts that were seen if we navigate back using 'back'
                %button   
                cla(haxes_1);
                cla(haxes_2);
                
                 %setting the heading and explanaion text
                set(htext_panel,'title','3. Filtered Signals');
                set(hexp_text,'string',strcat('The four signals have been successfully',...
                    ' filtered and are now band-limited to 3kHz.'));

                %setting the selection list of popup menu 1
                set(hpop_1,'value',1,'string',{'Signal 1','Signal 2','Signal 3','Signal 4'});
                
                %managing the axes labels and updating graphs
                update_graphs(); 
                
                
            case 5%------------------------------------------------------------------------------------------
                
                %clear any graphs present in the axes. Added to remove some
                %artifacts that were seen if we navigate back using 'back'
                %button   
                cla(haxes_1);
                cla(haxes_2);
                if previous_screen==6
                    %making required gui elements visible
                    set(hpop_1,'visible','on');
                end
                %setting the heading and explanaion text
                set(htext_panel,'title','4. Modulated Signals');
                set(hexp_text,'string',strcat('The filtered signals 1, 2, 3 and 4 are then modulated',...
                    ' with cosines of frequency 3, 9, 15 and 21kHz respectively.',...
                    ' The modulated signals are shown below.'));

                %setting the selection list of popup menu 1
                set(hpop_1,'value',1,'string',{'Signal 1','Signal 2','Signal 3','Signal 4'});
                
                %managing the axes labels and updating graphs
                update_graphs(); 
                
            case 6%------------------------------------------------------------------------------------------
                
                %clear any graphs present in the axes. Added to remove some
                %artifacts that were seen if we navigate back using 'back'
                %button   
                cla(haxes_1);
                cla(haxes_2);
                
                if previous_screen==5
                    %making unneeded gui elements invisible
                    set(hpop_1,'visible','off');
                
                elseif previous_screen==7
                    %making unneeded gui elements invisible
                    set([hpop_1,hpop_2],'visible','off');
                    %making required gui elements visible
                    set(haudio_1,'visible','on');
                end
                
                %setting the heading and explanaion text
                set(htext_panel,'title','5. Trasmission Signal');
                set(hexp_text,'string',strcat('The four modulated signals are added',...
                    ' to form the final signal to be transmitted. We assume that',...
                    ' this signal is transmitted through an ideal channel.'));
                              
                %managing the axes labels and updating graphs
                update_graphs(); 
                
            case 7%------------------------------------------------------------------------------------------
                
                %clear any graphs present in the axes. Added to remove some
                %artifacts that were seen if we navigate back using 'back'
                %button   
                cla(haxes_1);
                cla(haxes_2);
                if previous_screen==6
                    %making required gui elements visible
                    set([hpop_1,hpop_2],'visible','on');
                    %making unneeded gui elements invisible
                    set(haudio_1,'visible','off');
                
                elseif previous_screen==8
                    %making required gui elements visible
                    set(hpop_2,'visible','on');
                    %making unneeded gui elements invisible
                    set(haudio_1,'visible','off');
                end
                
                %setting the heading and explanaion text
                set(htext_panel,'title','6. Band-Pass Filters');
                set(hexp_text,'string',strcat('At the recieving end, the',...
                    ' transmitted signal is passed through four bandpass filters',...
                    ' of 6kHz bandwidth centred at 3, 9, 15 and 21kHz respectively.',...
                    'The desired filter type can be selected below.'));
                       
                %setting the selection list of popup menus
                set(hpop_1,'value',1,'string',{'IIR Butterworth','IIR Elliptic','FIR Least-Squares','FIR Window (Rectangular)'});
                set(hpop_2,'value',1,'string',{'0-6kHz (For Signal 1)','6-12kHz (For Signal 2)','12-18kHz (For Signal 3)','18-24kHz (For Signal 4)'});
                
                %managing the axes labels and updating graphs
                update_graphs(); 
                
            case 8%------------------------------------------------------------------------------------------
                
                if previous_screen==7
                    perform_calculations();
                    %making required gui elements visible
                    set(haudio_1,'visible','on');
                    %making unneeded gui elements invisible
                    set(hpop_2,'visible','off');
                end
                
                %clear any graphs present in the axes. Added to remove some
                %artifacts that were seen if we navigate back using 'back'
                %button   
                cla(haxes_1);
                cla(haxes_2);
                
                %setting the heading and explanaion text
                set(htext_panel,'title','7. Recovered Modulated Signals');
                set(hexp_text,'string',strcat('After filtering, the',...
                    ' modulated forms of original signals have been recovered.'));

                %setting the selection list of popup menu 1
                set(hpop_1,'value',1,'string',{'Signal 1','Signal 2','Signal 3','Signal 4'});
                
                %managing the axes labels and updating graphs
                update_graphs(); 
                
                    
               
            case 9%------------------------------------------------------------------------------------------
                
                %clear any graphs present in the axes. Added to remove some
                %artifacts that were seen if we navigate back using 'back'
                %button   
                cla(haxes_1);
                cla(haxes_2);
                if previous_screen==10
                    %making required gui elements visible
                    set(haudio_1,'visible','on');
                end
                
                %setting the heading and explanaion text
                set(htext_panel,'title','8. Demodulated Signals');
                set(hexp_text,'string',strcat('After demodulation, we nearly have the',...
                    ' original signals. There is still some high frequency noise present',...
                    ' that has been produced by the demodulation process.'));

                %setting the selection list of popup menu 1
                set(hpop_1,'value',1,'string',{'Signal 1','Signal 2','Signal 3','Signal 4'});
                
                %managing the axes labels and updating graphs
                update_graphs(); 
                
            case 10%------------------------------------------------------------------------------------------
                
                %clear any graphs present in the axes. Added to remove some
                %artifacts that were seen if we navigate back using 'back'
                %button   
                cla(haxes_1);
                cla(haxes_2);
                if previous_screen==9
                    %making unneeded gui elements invisible
                    set(haudio_1,'visible','off');
                
                elseif previous_screen==11
                    %making unneeded gui elements invisible
                    set([haudio_1,haudio_2,hpop_2],'visible','off');
                end
                
                %setting the heading and explanaion text
                set(htext_panel,'title','9. Low Pass Filter');
                set(hexp_text,'string',strcat('The four signals are passed through a',...
                    ' 3kHz lowpass filter. This removes the high frequency noise.',...
                    ' The desired type of lowpass filter can be chosen below.'));

                %setting the selection list of popup menu 1
                set(hpop_1,'value',1,'string',{'IIR Butterworth','IIR Elliptic','FIR Least-Squares','FIR Window (Rectangular)'});
                
                %managing the axes labels and updating graphs
                update_graphs(); 
                
            case 11%------------------------------------------------------------------------------------------
                
                 if previous_screen==10
                     perform_calculations();
                    %making required gui elements visible
                    set([hpop_2,haudio_1,haudio_2],'visible','on');
                    
                elseif previous_screen==12
                    %making unneeded gui elements invisible
                    set([hsave_panel,hsave_text,hsave_edit,...
                        hsave_but,hexit_but,hend_back_but],...
                        'visible','off');

                    %as the parent figure is resizing if coming from 12, 
                    %all sizes must be reset
                    screen_size=get(0,'screensize');
                    x_dist=0.5*(screen_size(3)-800);
                    y_dist=0.5*(screen_size(4)-625);
                    set(hmain_figure,'resize','on','position',[x_dist y_dist 800 625]);
                    set(htext_panel,'position',[100 555 650 60]);
                    set(hexp_text,'position',[5 5 640 30]);
                    set(hpop_1,'position',[100 520 150 30]);
                    set(hpop_2,'position',[260 520 150 30]);
                    set(haudio_1,'position',[650 525 100 23]);
                    set(haudio_2,'position',[650 270 100 23]);
                    set(haxes_1,'position',[100 335 650 165]);
                    set(haxes_2,'position',[100 95 650 165]);
                    set(hnext_but,'position',[700 25 50 23]);
                    set(hback_but,'position',[100 25 50 23]);

                    %set units to normalized to allow bug-free resizing
                    set([hmain_figure,htext_panel,hexp_text,hpop_1,hpop_2,haudio_1,...
                     haudio_2,haxes_1,haxes_2,hnext_but,hback_but],'units','normalized');

                    %setting the required gui elements visible
                    set([htext_panel,hexp_text,hpop_1,hpop_2,haudio_1,...
                     haudio_2,haxes_1,haxes_2,hnext_but,hback_but],'visible','on');
                 end
                
                %clear any graphs present in the axes. Added to remove some
                %artifacts that were seen if we navigate back using 'back'
                %button   
                cla(haxes_1);
                cla(haxes_2);
                 
                %setting the heading and explanaion text
                set(htext_panel,'title','10. Final Recovered Signals');
                set(hexp_text,'string',strcat('After filteration (and amplification by a factor of 2), we finally have',...
                    ' our recovered signals. They are presented in parallel with the original signals.'));

                %setting the selection list of popup menu 1
                set(hpop_1,'string',{'Signal 1','Signal 2','Signal 3','Signal 4'},'value',1);
                set(hpop_2,'string',{'Time Domain','Frequency Domain'},'value',1)
                
                %managing the axes labels
                update_graphs();
                
            case 12%------------------------------------------------------------------------------------------
                
                %clear any graphs present in the axes. Added to remove some
                %artifacts that were seen if we navigate back using 'back'
                %button   
                cla(haxes_1);
                cla(haxes_2);
                set([hmain_figure,htext_panel,hexp_text,hpop_1,hpop_2,haudio_1,...
                 haudio_2,haxes_1,haxes_2,hnext_but,hback_but],'units','pixels');
                
                %locating the screen center
                screen_size=get(0,'screensize');
                x_dist=0.5*(screen_size(3)-400);
                y_dist=0.5*(screen_size(4)-300);
                %placing the figure at the screen center
                set(hmain_figure,'resize','off','position',[x_dist y_dist 400 300]);
                
                %set unnecessary ui elements invisible
                set([htext_panel,hexp_text,hpop_1,hpop_2,haudio_1,...
                 haudio_2,haxes_1,haxes_2,hnext_but,hback_but],'visible','off');
                
                %set necessary ui elements visible
                set([hsave_panel,...
                 hsave_text,hsave_edit,hsave_but,hexit_but,hend_back_but],...
                    'visible','on');                      
            
        end %end switch-case
    %end-function    
    end 
    
    %this function performs all the calculations. Calculations are
    %performed after each screen containing selectable filters. All
    %calulcations up till the next such screen are performed in one go.
    %waitbars show the calculation progress
    function perform_calculations()
        
        %while calculations are being performed, lock all navigational
        %buttons
        navigation_free=0;
        
        %selection of calculations based on current screen number
        switch current_screen
            case 2
                %completion percentage
                comp_per=0;
                hwaitbar=waitbar(comp_per,'Calculating...0%%');
                %loading the signals from audio files
                for k=1:4
                    hwaitbar=update_waitbar(comp_per,hwaitbar);
                    [sig{k},fs]=audioread(sprintf('s%d.wav',k));
                    comp_per=comp_per+0.075;
                end
                %truncating them to same length
                [sig{1},sig{2},sig{3},sig{4}]=truncate_to_smallest(sig{1},sig{2},sig{3},sig{4});
                
                %taking transpose to turn them into row vectors
                for k=1:4
                    sig{k}=sig{k}';
                end
                
                %calculating f and t vectors
                [t,f]=get_tandf(sig{1},fs);
                
                %calculating and storing impulse responses of all filters
                %generating impulse to find impulse response
                imp=zeros(1,length(t));
                imp(round(length(t)/2))=length(t);
                
                %first lowpass filters
                for tech=1:4
                    hwaitbar=update_waitbar(comp_per,hwaitbar);
                    fil_ir{tech}{1}=customfilter(imp,fil_tech{tech},'lowpass');
                    comp_per=comp_per+0.075;
                end
                
                %for bandpass filters
                for tech=1:4
                    for band=1:4
                        hwaitbar=update_waitbar(comp_per,hwaitbar);
                        fil_ir{tech}{band+1}=customfilter(imp,fil_tech{tech},'bandpass',band);
                        comp_per=comp_per+0.025;
                    end
                end
                %final update to waitbar
                hwaitbar=update_waitbar(comp_per,hwaitbar);
                %closing the waitbar. try-catch block avoids any errors
                %causes by the user having accidentally closed the waitbar
                %manually
                try
                close(hwaitbar);                
                catch
                end
                
            case 4
                %retrieving selected lpf
                lpf_tech=get(hpop_1,'value');
                
                %completion percentage
                comp_per=0;
                hwaitbar=waitbar(comp_per,'Calculating...0%%');
                
                %applying the filter to the 4 signals
                for k=1:4
                   sig_fil{k}=customfilter(sig{k},fil_tech{lpf_tech},'lowpass'); 
                   comp_per=comp_per+0.24;
                   hwaitbar=update_waitbar(comp_per,hwaitbar);
                end
                
                %now obtaining the modulated signals
                mod_freq=[3 9 15 21]*1000; %modulation frequencies
                for k=1:4
                   sig_mod{k}=custommodulate(sig_fil{k},t,mod_freq(k));
                end
                %now obtaining the final transmission signal
                sig_trans=sig_mod{1}+sig_mod{2}+sig_mod{3}+sig_mod{4};   
                
                %final update to waitbar
                comp_per=comp_per+0.04;
                hwaitbar=update_waitbar(comp_per,hwaitbar);
                
                %closing the waitbar. try-catch block avoids any errors
                %causes by the user having accidentally closed the waitbar
                %manually
                try
                close(hwaitbar);                
                catch
                end
                
            case 8
                %retrieving selected bpf
                bpf_tech=get(hpop_1,'value');
                
                %completion percentage
                comp_per=0;
                hwaitbar=waitbar(comp_per,'Calculating...0%%');
                
                %applying band pass filters to recover the modulated
                %signals
                for k=1:4
                   sig_mod_rec{k}=customfilter(sig_trans,fil_tech{bpf_tech},'bandpass',k); 
                   comp_per=comp_per+0.24;
                   hwaitbar=update_waitbar(comp_per,hwaitbar);
                end
                
                %demodulating the signals
                mod_freq=[3 9 15 21]*1000; %modulation frequencies
                for k=1:4
                   sig_demod{k}=custommodulate(sig_mod_rec{k},t,mod_freq(k));
                end
                
                %final update to waitbar
                comp_per=comp_per+0.04;
                hwaitbar=update_waitbar(comp_per,hwaitbar);
                
                %closing the waitbar. try-catch block avoids any errors
                %causes by the user having accidentally closed the waitbar
                %manually
                try
                close(hwaitbar);                
                catch
                end
                
                
            case 11
                %retrieving selected lpf
                lpf_tech=get(hpop_1,'value');
                
                %completion percentage
                comp_per=0;
                hwaitbar=waitbar(comp_per,'Calculating...0%%');
                
                %applying the filter to the 4 signals
                for k=1:4
                   sig_final{k}=2*customfilter(sig_demod{k},fil_tech{lpf_tech},'lowpass'); 
                   comp_per=comp_per+0.25;
                   hwaitbar=update_waitbar(comp_per,hwaitbar);
                end
                
                %closing the waitbar. try-catch block avoids any errors
                %causes by the user having accidentally closed the waitbar
                %manually
                try
                close(hwaitbar);                
                catch
                end
        end %end switch-case
    %allow navigation
    navigation_free=1;           
    %end function
    end

    %this function updates the axes with the new graphs according to
    %current screen number
    function update_graphs()
        
        %deciding what signal to graph based on current screen
        switch current_screen

            case 2
                %find which signal is selected in popup menu
                selected_sig=get(hpop_1,'value');
                
                %plot the signal in time and frequency domains
                plot(haxes_1,t,sig{selected_sig});
                plot(haxes_2,f,spectrum(sig{selected_sig}));
                xlabel(haxes_1,'t(s)');
                ylabel(haxes_1,'Time Domain');
                xlabel(haxes_2,'f(Hz)');
                ylabel(haxes_2,'Frequency Domain');
                
            case 3
                
                %find which filter is selected
                selected_fil=get(hpop_1,'value');
                
                %obtain a two-sided time vector for impulse response
                t1=t-t(end)/2;
                
                %whole impulse response too large so finding a small section 'b' to
                %zoom to
                a=0.5*length(t);
                b=-0.005*fs+a:+0.005*fs+a;
                
                %plot the graphs
                plot(haxes_1,t1(b),fil_ir{selected_fil}{1}(b)/length(t));
                plot(haxes_2,f,spectrum(fil_ir{selected_fil}{1}));
                ylim(haxes_2,[0 1.2]);
                xlabel(haxes_1,'t(s)');
                ylabel(haxes_1,'Impulse Response');
                xlabel(haxes_2,'f(Hz)');
                ylabel(haxes_2,'Frequency Response');
                
            case 4
                
                %find which signal is selected in popup menu
                selected_sig=get(hpop_1,'value');
                
                %plot the signal in time and frequency domains
                plot(haxes_1,t,sig_fil{selected_sig});
                plot(haxes_2,f,spectrum(sig_fil{selected_sig}));
                xlabel(haxes_1,'t(s)');
                ylabel(haxes_1,'Time Domain');
                xlabel(haxes_2,'f(Hz)');
                ylabel(haxes_2,'Frequency Domain');
                
            case 5
                
                %find which signal is selected in popup menu
                selected_sig=get(hpop_1,'value');
                
                %plot the signal in time and frequency domains
                plot(haxes_1,t,sig_mod{selected_sig});
                plot(haxes_2,f,spectrum(sig_mod{selected_sig}));
                xlabel(haxes_1,'t(s)');
                ylabel(haxes_1,'Time Domain');
                xlabel(haxes_2,'f(Hz)');
                ylabel(haxes_2,'Frequency Domain');
                
            case 6
                
                %plot the final transmission signal in time and frequency domains
                plot(haxes_1,t,sig_trans);
                plot(haxes_2,f,spectrum(sig_trans));
                xlabel(haxes_1,'t(s)');
                ylabel(haxes_1,'Time Domain');
                xlabel(haxes_2,'f(Hz)');
                ylabel(haxes_2,'Frequency Domain');
                
            case 7
                
                %find which technology of bandpass filter is selected
                tech=get(hpop_1,'value');
                
                %find frequency band of selected filter
                band=get(hpop_2,'value');
                
                %obtain a two-sided time vector for impulse response
                t1=t-t(end)/2;
                
                %whole impulse response is too large so finding a small section 'b' to
                %zoom to
                a=0.5*length(t);
                b=-0.005*fs+a:+0.005*fs+a;
                
                %plot the graphs
                plot(haxes_1,t1(b),fil_ir{tech}{band+1}(b)/length(t));
                plot(haxes_2,f,spectrum(fil_ir{tech}{band+1}));
                ylim(haxes_2,[0 1.2]);
                xlabel(haxes_1,'t(s)');
                ylabel(haxes_1,'Impulse Response');
                xlabel(haxes_2,'f(Hz)');
                ylabel(haxes_2,'Frequency Response');
                
            case 8
                
                %find which signal is selected in popup menu
                selected_sig=get(hpop_1,'value');
                
                %plot the graphs
                plot(haxes_1,t,sig_mod_rec{selected_sig});
                plot(haxes_2,f,spectrum(sig_mod_rec{selected_sig}));
                xlabel(haxes_1,'t(s)');
                ylabel(haxes_1,'Time Domain');
                xlabel(haxes_2,'f(Hz)');
                ylabel(haxes_2,'Frequency Domain');
                
            case 9
                
                %find which signal is selected in popup menu
                selected_sig=get(hpop_1,'value');
                
                %plot the graphs
                plot(haxes_1,t,sig_demod{selected_sig});
                plot(haxes_2,f,spectrum(sig_demod{selected_sig}));
                xlabel(haxes_1,'t(s)');
                ylabel(haxes_1,'Time Domain');
                xlabel(haxes_2,'f(Hz)');
                ylabel(haxes_2,'Frequency Domain');
                
            case 10
                
                %find which filter is selected
                selected_fil=get(hpop_1,'value');
                
                %obtain a two-sided time vector for impulse response
                t1=t-t(end)/2;
                
                %whole impulse response too large so finding a small section 'b' to
                %zoom to
                a=0.5*length(t);
                b=-0.005*fs+a:+0.005*fs+a;
                
                %plot the graphs
                plot(haxes_1,t1(b),fil_ir{selected_fil}{1}(b)/length(t));
                plot(haxes_2,f,spectrum(fil_ir{selected_fil}{1}));
                ylim(haxes_2,[0 1.2]);
                xlabel(haxes_1,'t(s)');
                ylabel(haxes_1,'Impulse Response');
                xlabel(haxes_2,'f(Hz)');
                ylabel(haxes_2,'Frequency Response');
                
            case 11
                
                %find which signal is selected
                selected_sig=get(hpop_1,'value');
                
                %find which domain (time/frequency) is selected
                selected_dom=get(hpop_2,'value');
                
                switch selected_dom %select on basis of domain
                    case 1
                        
                        %plot both signals in time domain
                        plot(haxes_1,t,sig_final{selected_sig});
                        plot(haxes_2,t,sig{selected_sig});
                        xlabel(haxes_1,'t(s)');
                        ylabel(haxes_1,'Recovered Signal');
                        xlabel(haxes_2,'t(s)');
                        ylabel(haxes_2,'Original Signal');
                    case 2
                        
                        %plot both signals in frequency domain
                        plot(haxes_1,f,spectrum(sig_final{selected_sig}));
                        plot(haxes_2,f,spectrum(sig{selected_sig}));
                        xlabel(haxes_1,'f(Hz)');
                        ylabel(haxes_1,'Recovered Signal');
                        xlabel(haxes_2,'f(Hz)');
                        ylabel(haxes_2,'Original Signal');
                end %end switch-case
            
            
        end %end switch-case
    %end function 
    end
    
    %updates the waitbar for calculations to value*100% and sends the new handle h
    function h=update_waitbar(value,hwaitbar)
        h=0;%declare h to a default value so function returns something if try fails
        
        %try block in case user accidentally manually deletes waitbar
        try
            %update waitbar
            h=waitbar(value,hwaitbar,sprintf('Calculating...%d%%',round(value*100)));
        catch
        end
    %end function
    end
    
    %updates the waitbar for saving to disk to value*100% and sends the new handle h
    function h=update_savebar(value,hwaitbar)
        h=0;%declare h to a default value so function returns something if try fails
        
        %try block in case user accidentally manually deletes waitbar
        try
            %update waitbar
            h=waitbar(value,hwaitbar,sprintf('Saving...%d%%',round(value*100)));
        catch
        end
    %end function
    end
    
    %returns the magnitude of fourier{x}
    function y=spectrum(x)
        y=abs(fftshift(fft(x)/length(x)));
    end

    %callback for 'next' button. Increments screen numbers and calls for
    %new screen to be displayed
    function next_but_callback(source,callback)
        if navigation_free %button does nothing during calculations when navigation is off
            %stop any audio before going to next screen
            stop_all_audio();
            %update screen numbers
            previous_screen=current_screen;
            current_screen=current_screen+1;
            %display new screen
            display_current_screen();
        end %end if
    %end function
    end

    %callback for 'back' button. Decrements screen numbers and calls for
    %new screen to be displayed
    function back_but_callback(source,callback)
        if navigation_free%button does nothing during calculations when navigation is off
            %stop any audio before going to next screen
            stop_all_audio();
            %update screen numbers
            previous_screen=current_screen;
            current_screen=current_screen-1;
            %display new screen
            display_current_screen();
        end %end if
    %end function
    end

    %callback function for popup/dropdown menus. It is called when user interacts
    %with any of such menus
    function popup_callback(source,callback)
        %stop all audio as user is likely to have selected a new signal
        stop_all_audio();
        %update graphs to display the new signal the user has selected
        update_graphs();
    %end function   
    end

    %callback function for any and all play/pause audio buttons
    function audio_callback(source,callback)
        but_mode=get(source,'string');  %is the command to 'play' or 'pause'
        
        %decide functionality based on the button mode
        switch but_mode
            case 'Stop Audio'   %audio must already be playing
                switch source   %decide next action based on which button 
                    %was pressed(some screens have 2 audio buttons). Stop
                    %the audio corresponding to whichever one was pressed
                    case haudio_1
                        stop(audio_1);
                    case haudio_2
                        stop(audio_2);
                end     %end switch-case
                %as audio has been stopped, the calling button must now
                %become a 'play' button again
                set(source,'string','Play Audio');
                
            case 'Play Audio'   %audio corresponding to the calling button
                %currently not playing but any other audio may still be
                %playing so stop that first if that is the case
                stop_all_audio();
                
                %before the audio even starts, the text switches to 'Stop
                %Audio'
                set(source,'string','Stop Audio');
                
                %The exact audio that is played obviously depends on the
                %current screen and the signal selected by the user. Thus
                %we once again have a switch-case based on the
                %current_screen variable
                switch current_screen
                    %cases are present for those screens only that have a
                    %play/pause button. In all cases, the signal number is determined by
                    %hpop_1.  Except for case 11, in the source is haudio_1. In
                    %case 11, it can be haudio_2 as well as well because
                    %both are present, thus calling for a nested
                    %switvh-case structure in case 11. Beyond this we
                    %consider the code in this function to be
                    %self-documenting.
                    case 2
                        audio_1=audioplayer(sig{get(hpop_1,'value')},fs);
                        play(audio_1);
                    case 4
                        audio_1=audioplayer(sig_fil{get(hpop_1,'value')},fs);
                        play(audio_1);
                    case 5
                        audio_1=audioplayer(sig_mod{get(hpop_1,'value')},fs);
                        play(audio_1);
                    case 6
                        audio_1=audioplayer(sig_trans,fs);
                        play(audio_1);
                    case 8
                        audio_1=audioplayer(sig_mod_rec{get(hpop_1,'value')},fs);
                        play(audio_1);
                    case 9
                        audio_1=audioplayer(sig_demod{get(hpop_1,'value')},fs);
                        play(audio_1);
                    case 11
                        switch source
                            case haudio_1
                                audio_1=audioplayer(sig_final{get(hpop_1,'value')},fs);
                                play(audio_1);
                            case haudio_2
                                audio_2=audioplayer(sig{get(hpop_1,'value')},fs);
                                play(audio_2);
                        end %end switch-case
                end %end switch-case
        
        end %end switch-case
    %end function    
    end

    %this function stops any audio that may be playing and reverts both
    %audio buttons to 'play' mode
    function stop_all_audio()
        %try catch in case trying to stop an already stopped audio throws
        %an error in any version of MATALB
        try
            %stop both audios
            stop(audio_1);
            stop(audio_2);
        catch
        end
        %set text for both audio buttons (whether visible or not), to 'Play
        %Audio'
        set([haudio_1,haudio_2],'string','Play Audio');
    %end function
    end
    
    %this function is the callback function for the 'save' button on the
    %last screen. It reads the path in the textbox and saves all signals in
    %that location
    function save_but_callback(source,callback)
        %get the path 
        save_path=get(hsave_edit,'string');
        %completion percentage initialized to zero
        comp_per=0;
        hwaitbar=waitbar(comp_per,'Saving...0%');
        
        %save all the signals 1 by 1 and update the percentage in the
        %waitbar. Self documenting code follows:
        save_audio(save_path,'OriginalSignals',fs,sig{1},sig{2},sig{3},sig{4}) 
        comp_per=comp_per+0.16;
        hwaitbar=update_savebar(comp_per,hwaitbar);
        
        save_audio(save_path,'FilteredSignals',fs,sig_fil{1},sig_fil{2},sig_fil{3},sig_fil{4}) 
        comp_per=comp_per+0.16;
        hwaitbar=update_savebar(comp_per,hwaitbar);
        
        save_audio(save_path,'ModulatedSignals',fs,sig_mod{1},sig_mod{2},sig_mod{3},sig_mod{4}) 
        comp_per=comp_per+0.16;
        hwaitbar=update_savebar(comp_per,hwaitbar);
        
        save_audio(save_path,'TransmittedSignal',fs,sig_trans) 
        comp_per=comp_per+0.04;
        hwaitbar=update_savebar(comp_per,hwaitbar);
        
        save_audio(save_path,'RecoveredModulatedSignals',fs,sig_mod_rec{1},sig_mod_rec{2},sig_mod_rec{3},sig_mod_rec{4}) 
        comp_per=comp_per+0.16;
        hwaitbar=update_savebar(comp_per,hwaitbar);
        
        save_audio(save_path,'DemodulatedSignals',fs,sig_demod{1},sig_demod{2},sig_demod{3},sig_demod{4}) 
        comp_per=comp_per+0.16;
        hwaitbar=update_savebar(comp_per,hwaitbar);
        
        save_audio(save_path,'FinalSignals',fs,sig_final{1},sig_final{2},sig_final{3},sig_final{4})
        comp_per=comp_per+0.16;
        hwaitbar=update_savebar(comp_per,hwaitbar);
        
        %closing the waitbar. try-catch block avoids any errors
        %causes by the user having accidentally closed the waitbar
        %manually
        try
            close(hwaitbar);                
        catch
        end %end try-catch
        
    end %end function

end %end function
