# I'm avoiding * because it seems like it could potentially be an issue
# I think it is inefficient to join three tables and get all relevant tuples, so ideally
# we should prune sites by a "org name" parameter, then join to clusters, prune by a
# "building name" parameter, then join to bin_weights, then filter by timestamp 
# and for more granularity, a particular cluster

# pre: start and end time (as str representation?), a cluster id
# post: relevant features (cluster id, readable name of cluster, org name, timestamp, 
# 	mode, change in weight, total weight, overweight status, ignore status) sorted chronologically
# note: since awd_ids is an integer array, I'm not sure if I can export that in a .csv 

# Mode Information
# Unknown = 0
# Landfill = 1,
# Compost = 2,
# Recycle = 3,
# Mixed Paper = 4

SELECT b.unit_id as Cluster ID 
	, c.name as Cluster Name
	, site.name as Organization 
	, b.timestamp as Timestamp 
	, b.mode as Bin mode
	, b.change as Weight change
	, b.weight as Total Weight
	, b.overweight as Overweight Status
	, b.ignore as Ignore Status 
FROM sites s
LEFT OUTER JOIN clusters c 
	ON s.id = c.site
LEFT OUTER JOIN  bin_weights b
	ON c.id = b.unit_id
WHERE b.timestamp > 'START' 
	AND b.timestamp < 'END'
	AND n.unit_id = 'CLUSTER ID'
ORDER BY b.timestamp; 
