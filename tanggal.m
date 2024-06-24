function selectedDate = tanggal(cals)
fig = uifigure('Position',[500 200 400 300],"Name","Pilih Tanggal",'WindowStyle','modal');
setappdata(fig, "SelectedDate", min(cals));
d = uidatepicker(fig,'DisplayFormat','MM-dd-yyyy',...
    'Position',[75 250 152 30],...
    'Value',(cals),...
    'ValueChangedFcn', @(obj,~) setappdata(fig, "SelectedDate", obj.Value));
fig.CloseRequestFcn = @(f,~) set(f,'WindowStyle','normal');
uibutton(fig,'Position',[75 200 100 30], "Text", "OK", "ButtonPushedFcn", @(~,~) close(fig));
waitfor(fig,'WindowStyle','normal');
selectedDate = getappdata(fig, "SelectedDate");
delete(fig);
end