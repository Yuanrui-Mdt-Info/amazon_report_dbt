
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

{{ config(materialized='table') }}


{% set test_csv_query %}
select _airbyte_data from {{ source('yuanrui_crawler', '_airbyte_raw_amazon_asin') }}
{% endset %}


{% set results = run_query(test_csv_query) %}


{% if execute %}
{# Return the first column #}
{% set results_list = results.columns[0].values() %}
{% else %}
{% set results_list = [] %}
{% endif %}


with source_data as (
    {% set k = 0 %}
    {% for result in results_list %}
        select
        {% set my_dict = fromjson(result) %}
        {% for item_key in my_dict.keys() %}
            '{{ my_dict[item_key] }}' as '{{ item_key }}'
            {% if loop.index < my_dict|length %}
                ,
            {% endif %}
        {% endfor %}
        {% if not loop.last %}
            union all
        {% endif %}
    {% endfor %}
)

select * from source_data 





/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
