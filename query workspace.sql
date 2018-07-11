#Select an org's bin_weights for a specified time period

SELECT bin_weights.*
FROM bin_weights, clusters, orgs
WHERE bin_weights.unit_id = clusters.id AND clusters.org = orgs.id AND orgs.name = '[org name]' AND 
    bin_weights.ignore = 'f' AND bin_weights.change > 0.200001;

#Select a site's bin_weights for a specified time period

SELECT bin_weights.*
FROM bin_weights, clusters, sites
WHERE bin_weights.unit_id = clusters.id AND clusters.site = sites.id AND sites.name = 'Pinterest NY'
    AND bin_weights.ignore = 'f' AND bin_weights.change > 0.200001;

#Copy an org's bin_weights for a specified time period to a CSV file
#Newlines causing conflicts with the copy command, so they're omitted from these query.
#Note: target csv file should be named with the pattern org_name-year-month.csv, i.e. 'pinterest_2018-may.csv'

\copy ( SELECT bin_weights.* FROM bin_weights, clusters, sites WHERE bin_weights.unit_id = clusters.id AND clusters.org = orgs.id AND orgs.name = '[org name]' AND bin_weights.timestamp BETWEEN '[start date]' AND '[end date]' AND bin_weights.ignore = 'f' AND bin_weights.change > 0.200001 ) TO '/home/evoeco/[file name].csv' DELIMITER ',' CSV;

#Copy a site's bin_weights for a specified time period to a CSV file

\copy ( SELECT bin_weights.* FROM bin_weights, clusters, sites WHERE bin_weights.unit_id = clusters.id AND clusters.site = sites.id AND sites.name = '[site name]' AND bin_weights.timestamp BETWEEN '[start date]' AND '[end date]' AND bin_weights.ignore = 'f' AND bin_weights.change > 0.200001 ) TO '/home/evoeco/[file name].csv' DELIMITER ',' CSV;


# WRITE SQL COMMANDS TO MERGE 3 TABLES AND DISPLAY RELEVANT DATA FOR CLIENTS