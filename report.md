
## Exploring Data

1.
    
    count 
    -------
    80014
    (1 row)
it shows that there is no null value in report_id, product, product_type and craeted_date columns

2.

    patient_age | age_unit 
    -------------+----------
    (0 rows)
It shows if age_unit is null then patient_age must be null too
    
3.

     report_id |   product   | cout 
    -----------+-------------+------
     173066    | EXEMPTION 4 |    5
     173307    | EXEMPTION 4 |    2
     173435    | EXEMPTION 4 |    2
     173455    | EXEMPTION 4 |    2
     173728    | EXEMPTION 4 |    2
    (5 rows)

it shows that many rows contain duplicate values with the composite columns (report_id, product)

4. 

        product_code |   product   |                  description                  
        --------------+-------------+-----------------------------------------------
         54           | EXEMPTION 4 |  Vit/Min/Prot/Unconv Diet(Human/Animal)
         54           | EXEMPTION 4 |  Vit/Min/Prot/Unconv Diet(Human/Animal)
         54           | EXEMPTION 4 |  Vit/Min/Prot/Unconv Diet(Human/Animal)
         54           | EXEMPTION 4 |  Vit/Min/Prot/Unconv Diet(Human/Animal)
         41           | EXEMPTION 4 |  Dietary Conventional Foods/Meal Replacements
     
it shows that product_code might be uniquely determine product, and description


5. 

        report_id    | count 
        -----------------+-------
         203819          |     1
         2018-CFS-006260 |     4
         209126          |     2
         183778          |     1
         194867          |     1
        (5 rows)


        report_id    | created_date |           product            
        -----------------+--------------+------------------------------
         2018-CFS-006260 | 2018-04-25   | CETAPHIL MOISTURIZING LOTION
         2018-CFS-006260 | 2018-04-25   | multi vitamin
         2018-CFS-006260 | 2018-04-25   | vitamin d
         2018-CFS-006260 | 2018-04-25   | fish oil
        (4 rows)

It turns out that there are duplicate rows, need to separate products from report

6.

     report_id | count 
    -----------+-------
    (0 rows)
So report_id could be a primary key alone

## Database Design
![alt text](ERDiagram.png "Title")

- I choose four entities: caers_event, product, outcome, and symptoms
- report is many to many relationship with the rest three entities
- there include three additional tables store the foreign keys between two many-to-many relationship tables
- the reason why many-to-many is, the reason, for outcome for example, an outcome can occur in many report, an report can have multiple outcomes


## Views and Index
1. sql result

        report_id    | product_name 
        -----------------+--------------
         176146          | FISH OIL
         176260          | FISH OIL
         178722          | FISH OIL
         180705          | FISH OIL
         206257          | FISH OIL
         210823          | FISH OIL
         211424          | FISH OIL
         212046          | FISH OIL
         213664          | FISH OIL
         217498          | FISH OIL
         2017-CFS-000411 | FISH OIL
         2017-CFS-001568 | FISH OIL
         2018-CFS-000306 | FISH OIL
         2018-CFS-005531 | FISH OIL
         2018-CFS-009819 | FISH OIL
         2018-CFS-009909 | FISH OIL
         2018-CFS-011925 | FISH OIL
        (17 rows)

        
add EXPLAIN ANALYZE


                                                                         QUERY PLAN                                                                 
        --------------------------------------------------------------------------------------------------------------------------------------------
         Nested Loop  (cost=703.18..2308.03 rows=2 width=42) (actual time=3.674..17.893 rows=17 loops=1)
           ->  Hash Join  (cost=702.89..2307.36 rows=2 width=42) (actual time=3.657..17.712 rows=17 loops=1)
                 Hash Cond: (r.product_id = p.product_id)
                 ->  Seq Scan on report_product r  (cost=0.00..1433.35 rows=65180 width=13) (actual time=0.016..9.610 rows=65114 loops=1)
                       Filter: (product_type = 'SUSPECT'::text)
                       Rows Removed by Filter: 9794
                 ->  Hash  (cost=702.88..702.88 rows=1 width=37) (actual time=2.973..2.973 rows=2 loops=1)
                       Buckets: 1024  Batches: 1  Memory Usage: 9kB
                       ->  Seq Scan on product p  (cost=0.00..702.88 rows=1 width=37) (actual time=1.772..2.970 rows=2 loops=1)
                             Filter: (product_name = 'FISH OIL'::text)
                             Rows Removed by Filter: 28068
           ->  Index Only Scan using caers_event_pkey on caers_event c  (cost=0.29..0.34 rows=1 width=9) (actual time=0.010..0.010 rows=1 loops=17)
                 Index Cond: (report_id = r.report_id)
                 Heap Fetches: 17
         Planning Time: 2.531 ms
         Execution Time: 18.343 ms
        (16 rows)

After adding index 

                                                                 QUERY PLAN                                                                 
    --------------------------------------------------------------------------------------------------------------------------------------------
     Nested Loop  (cost=4.62..726.49 rows=2 width=42) (actual time=2.312..3.944 rows=17 loops=1)
       ->  Nested Loop  (cost=4.33..725.82 rows=2 width=42) (actual time=2.293..3.863 rows=17 loops=1)
             ->  Seq Scan on product p  (cost=0.00..702.88 rows=1 width=37) (actual time=1.729..2.971 rows=2 loops=1)
                   Filter: (product_name = 'FISH OIL'::text)
                   Rows Removed by Filter: 28068
             ->  Bitmap Heap Scan on report_product r  (cost=4.33..22.90 rows=4 width=13) (actual time=0.341..0.434 rows=8 loops=2)
                   Recheck Cond: (product_id = p.product_id)
                   Filter: (product_type = 'SUSPECT'::text)
                   Rows Removed by Filter: 176
                   Heap Blocks: exact=212
                   ->  Bitmap Index Scan on product_index  (cost=0.00..4.33 rows=5 width=0) (actual time=0.318..0.318 rows=185 loops=2)
                         Index Cond: (product_id = p.product_id)
       ->  Index Only Scan using caers_event_pkey on caers_event c  (cost=0.29..0.34 rows=1 width=9) (actual time=0.004..0.004 rows=1 loops=17)
             Index Cond: (report_id = r.report_id)
             Heap Fetches: 17
     Planning Time: 1.555 ms
     Execution Time: 3.983 ms
    (17 rows)
    
    
The index definitely worked since the same query works much faster (execution time drops from 18ms to 4ms)



### views 
the view is not consistent with the original table, it has a lot more rows than the staging table. The reason is that I unnest the symptom column into rows

### general query 

3.1 

                product_name                | patient_age | age_unit 
        --------------------------------------------+-------------+----------
         BLUE BUNNY FROZEN YOGURT NO SUGAR ADDED    |          81 | year(s)
         DANNON BLUEBERRY YOGURT                    |          74 | year(s)
         DANNON BLUEBERRY YOGURT                    |          74 | year(s)
         DANNON ACTIVIA LIGHT FAT FREE PEACH YOGURT |          73 | year(s)
         DANNON ACTIVIA LIGHT FAT FREE PEACH YOGURT |          73 | year(s)
        (5 rows)
        
3.2

         product_name          | product_code 
    -------------------------------+--------------
     5-HTP                         | 54
     ALTERIL ALL NATURAL SLEEP AID | 54
     B COMPLEX                     | 54
     BETA CAROTENE                 | 54
     BIOTIN                        | 54
    (5 rows)
    
3.3

     report_id |                                                                           string_agg                                                                           
    -----------+----------------------------------------------------------------------------------------------------------------------------------------------------------------
     172934    | HYPERSENSITIVITY, DYSGEUSIA
     172937    | CAUSTIC INJURY, PAIN, BURNING SENSATION, TENDERNESS, MUCOSAL ULCERATION
     172939    | FEELING HOT, BODY TEMPERATURE INCREASED, ABDOMINAL PAIN, VOMITING, MALAISE, GASTROINTESTINAL DISORDER, FLUSHING, FEELING OF BODY TEMPERATURE CHANGE, DYSPEPSIA
     172940    | NAUSEA
     172941    | LACERATION
    (5 rows)
    
    
3.4

     event_date | report_id |                    product_name                     
    ------------+-----------+-----------------------------------------------------
     2013-09-29 | 172989    | RESER'S STONEMILL KITCHENS COUNTRY RED POTATO SALAD
     2013-09-29 | 172990    | RESER'S STONEMILL KITCHENS COUNTRY RED POTATO SALAD
     2013-09-29 | 172991    | RESER'S STONEMILL KITCHENS COUNTRY RED POTATO SALAD
     2013-09-29 | 172992    | RESER'S STONEMILL KITCHENS COUNTRY RED POTATO SALAD
     2013-09-29 | 172993    | RESER'S STONEMILL KITCHENS COUNTRY RED POTATO SALAD
    (5 rows)
    
    
3.5

    created_date 
    --------------
    2019-03-30
    (1 row)
    
        report_id    |                 product_name                  | created_date 
    -----------------+-----------------------------------------------+--------------
     2019-CFS-003295 | 100% CREATINE MONOHYDRATE                     | 2019-03-30
     2019-CFS-003289 | NEUROPRO GENTLEASE READY TO USE LIQUD FORMULA | 2019-03-30
    (2 rows)
    
    
    
    
## Conclusions
Using this semi-normalized tables could deal with many-to-many relationship better. for example, if I want to find out what is the most common symptom of all the recorded events, using non-normalized table would require dealing with array of symptoms, while using semi-normalized, in query we only need to join tables 

downside of using semi-normalized table is that it takes time to design ER Diagram and create tables, and some simple query many be easier to conduct in a non-normalized table. For example like finding the most recent recorded event would not necessarily require a normalized table in this case.  