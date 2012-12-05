When /^request the "(.*?)" facet$/ do |arg1|
  @params['facets'] = arg1
end

Then /^the API returns the "(.*?)" terms facets$/ do |arg1|
  facets = arg1.split(/,\s*/)
  @results = item_query(@params)
  expect(@results['facets'].keys).to match_array facets
end

Then /^the "(.*?)" terms facets contains items for every unique dplaContributor within the (search index|results set)$/ do |facet_list, junk|

  @facets = facet_list.split(/,\s*/)
  @source = compute_facets(@facets, @query_string)

  @facets.each do |facet|
    expect(
           @results['facets'][facet]['terms'].map {|f| f['term']}
           ).to match_array @source[facet].keys
  end
end

Then /^each item within each facet contains a count of matching items$/ do
  @facets.each do |facet|
    expect(
           @results['facets'][facet]['terms'].map {|f| [f['term'], f['count']] }.flatten
           ).to match_array @source[facet].flatten
  end
end

Then /^the API returns items that contain the query string$/ do
  results = item_query(@params)
  results['docs'].each do |doc|
    expect(doc.values.any? {|value| value =~ /#{@query_string}/} ).to be_true
  end
end

