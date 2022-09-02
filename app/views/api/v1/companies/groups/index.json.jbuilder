json.array! @groups do |group|
  json.partial! 'api/v1/companies/groups/group', group: group
end
