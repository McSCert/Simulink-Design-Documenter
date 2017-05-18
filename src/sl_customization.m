%% Register custom menu function to beginning of Simulink Editor's context menu
function sl_customization(cm)
    cm.addCustomMenuFcn('Simulink:PreContextMenu', @getMcMasterTool);
end

%% Define custom menu function
function schemaFcns = getMcMasterTool(callbackInfo) 
    schemaFcns = {@getGenSDD};
end

%% Define the first action: GenSDD
function schema = getGenSDD(callbackinfo)
    schema = sl_action_schema;
    schema.label = 'Generate Simulink Design Document';
    schema.userdata = 'gensdd';
    schema.callback = @GenSDDCallback;
end

function GenSDDCallback(callbackInfo)
    GenSDD(gcs);
end