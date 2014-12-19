function dnsim2lems_noparms(spec,outfile,tspan,dt)
% Purpose: convert DNSim model into LEMS format....

% Example usage: 
% load('Morris-Lecar-Neuron.mat','spec');  % Load DNSim model specification
% dnsim2lems_noparms(spec,'LEMS_Morris-Lecar-Neuron.xml',[0 1000],.05);

% Info needed from the DNSim specification:
model=spec.model.ode;            % function handle string containing full ODE system
IC=spec.model.IC;                % vector of initial conditions
varlist = spec.variables.labels; % cell array of state variable names

% Make the model more human-readable --
% Substitute generic state vectors for meaningful variable names
for k = 1:length(varlist)
  varindex = sprintf('X(%g:%g)',k,k);
  varlist{k}=strrep(varlist{k},'_','');
  model = strrep(model,varindex,varlist{k});
end

% Eliminate unsupported Matlab syntax
model = strrep(model,'./','/');
model = strrep(model,'.*','*');
model = strrep(model,'.^','^');  

% Split the function handle string into a cell array of ODEs
odes = regexp(model(9:end-2),';','split');
odes = odes(~cellfun(@isempty,odes));


% Write LEMS ODE file
fid=fopen(outfile,'wt');
fprintf(fid,'<Lems>\n');
fprintf(fid,'  <Target component="sim1"/>\n');
fprintf(fid,'  <!-- Include core NeuroML2 ComponentType definitions -->\n  <Include file="Cells.xml"/>\n  <Include file="Networks.xml"/>\n  <Include file="Simulation.xml"/>\n\n');


fprintf(fid,'  <ComponentType name="myComponent"> <!-- Define the model -->\n\n');

fprintf(fid,'    <!-- Needed to ensure state variables remain dimensionless... -->\n');
fprintf(fid,'    <Constant name="MSEC" dimension="time" value="1ms"/>\n\n');

for k = 1:length(varlist)
  fprintf(fid,'    <Exposure name="%s" dimension="none"/>\n',varlist{k});
end

fprintf(fid,'\n');

fprintf(fid,'    <Dynamics>\n\n');
for k = 1:length(varlist)
  fprintf(fid,'      <StateVariable name="%s" dimension="none" exposure="%s"/>\n',varlist{k},varlist{k});
end

fprintf(fid,'\n');

for k = 1:length(varlist)
  fprintf(fid,'      <TimeDerivative variable="%s" value="%s/MSEC"/>\n',varlist{k},odes{k});
end

fprintf(fid,'\n      <OnStart>\n');

for k = 1:length(varlist)
  fprintf(fid,'        <StateAssignment variable="%s" value="%g"/>\n',varlist{k},IC(k));
end

fprintf(fid,'      </OnStart>\n\n');


fprintf(fid,'    </Dynamics>\n');



fprintf(fid,'  </ComponentType>\n\n');

fprintf(fid,'  <myComponent id="c0"/> <!--Create an instance -->\n\n');


% Write additional controls
fprintf(fid,'  <Simulation id="sim1" length="%g ms" step="%g ms" target="c0">\n\n',tspan(2),dt);

fprintf(fid,'    <Display id="d1" title="Test simulation" timeScale="1ms" xmin="0" xmax="%g" ymin="-80" ymax="30">\n',tspan(2));

colors = {'#000000';'#FF0000';'#00FF00';'#0000FF'};

for k = 1:length(varlist)
    fprintf(fid,'      <Line id ="%s" quantity="%s" scale="1" color="%s" timeScale="1ms"/>\n',varlist{k},varlist{k}, colors{k});
end 

fprintf(fid,'  </Display>\n\n');

fprintf(fid,'  </Simulation>\n');


fprintf(fid,'</Lems>');

fclose(fid);
