class ActiveAdmin::Views::Pages::Show
  def generate_json_from_hash hash
    hash.each_pair.map do |key, value|
      k = key.to_s.camelize.gsub!(/\b\w/) { $&.downcase }
      %|"#{k}": #{generate_json_from_value value}|
    end.flatten.join(',')
  end

  def generate_json_from_value value
    if value.is_a? Hash
      %|{ #{generate_json_from_hash value} }|
    elsif value.is_a? Array
      %|[ #{generate_json_from_array value} ]|
    elsif value.respond_to?(:js_code) && value.js_code?
      value
    else
      value.to_json
    end
  end

  def generate_json_from_array array
    array.map{|value| generate_json_from_value(value)}.join(",")
  end
end

ActiveAdmin.register Market do
  show do
    panel "Market details" do
      attributes_table_for market do
        row("id")
        row("name")
        row("country_iso3")
        row("event_type_id")
        row("status")
        row("suspend_time")
        row("time")
        row("type")
        row("type_variant")
        row("path")
        row("type_name")
        row("selections_no")
        row("number_of_winners")
      end
    end

    series = {}
    panel "Selections" do
      table_for market.selections do
        column :id, :width => 100
        column :name
        column :graph do |s|
          div :id => "graph_" + s.id.to_s, :style => 'width:100%; height:400px;' do
            ms = MarketSelection.find_by_market_id_and_selection_id(market.id, s.id)
            series[s.id] = []
            ms.selection_values.all(:order => "updated_at asc").each do |sv|
              series[s.id] << [sv.updated_at, sv.last_price_matched.to_f]
              #series << sv.total_amount_matched.to_f
              #series << sv.total_amount_matched.to_f + 100
            end
            #series = [2800.4, 3100.5, 200.5]
            @chart = LazyHighCharts::HighChart.new('line') do |f|
              f.series(:name=>s.name,:data => series[s.id])
              f.title({ :text=>market.name})

              ###  Options for Bar
              ### f.plot_options({:series=>{:stacking=>"normal"}})

              ## or options for column
              f.options[:chart][:defaultSeriesType] = "line"
              f.options[:xAxis][:type] = "datetime"
              f.options[:xAxis][:dateTimeLabelFormats] = {
                                  month: '%e. %b',
                                  year: '%b'
                              }
              f.plot_options({:column=>{:stacking=>"normal"}})
            end
            high_chart("graph_" + s.id.to_s, @chart)
            #"<script type='text/javascript'>
            #    $(function () {
            #        $('#graph_#{s.id.to_s}').highcharts({
            #            chart: {
            #                type: 'spline'
            #            },
            #            title: {
            #                text: 'Evolution for #{s.name}'
            #            },
            #            xAxis: {
            #                type: 'datetime',
            #                dateTimeLabelFormats: { // don't display the dummy year
            #                    month: '%e. %b %H:%m',
            #                    year: '%b'
            #                }
            #            },
            #            yAxis: {
            #                title: {
            #                    text: 'Total amount matched'
            #                },
            #                min: 0
            #            },
            #            tooltip: {
            #                formatter: function() {
            #                        return '<b>'+ this.series.name +'</b><br/>'+
            #                        Highcharts.dateFormat('%e. %b %H:%m', this.x) +': '+ this.y;
            #                }
            #            },
            #
            #            series: [{
            #                name: '#{s.name}',
            #                data: [
            #                                    #{generate_json_from_array(series)}
            #                ]
            #            }]
            #        });
            #    });
            #    </script>".html_safe
          end
        end
      end
    end

    div :id => 'graph_total', :style => 'width:100%; height:' + (400 + series.size * 40).to_s + 'px;' do
      @chart = LazyHighCharts::HighChart.new('line') do |f|
        MarketSelection.find_all_by_market_id(market.id).each do |ms|
          f.series(:name=>ms.selection.name,:data => series[ms.selection.id])
        end
        f.title({ :text=>market.name})

        ###  Options for Bar
        ### f.plot_options({:series=>{:stacking=>"normal"}})

        ## or options for column
        f.options[:chart][:defaultSeriesType] = "line"
        f.options[:xAxis][:type] = "datetime"
        f.options[:xAxis][:dateTimeLabelFormats] = {
                            month: '%e. %b',
                            year: '%b'
                        }
        f.plot_options({:column=>{:stacking=>"normal"}})
      end
      high_chart('graph_total', @chart)
    end

    active_admin_comments
  end
end
