-- 8.2 Using Parameters in Procedures

CREATE OR REPLACE PROCEDURE get_country_info(p_country_id IN NUMBER) AS
l_country_name wf_countries.country_name%TYPE;
l_capitol wf_countries.capitol%TYPE;
BEGIN
    SELECT country_name, capitol
    INTO l_country_name, l_capitol
    FROM wf_countries
    WHERE country_id = p_country_id;
    DBMS_OUTPUT.PUT_LINE(l_country_name || 'and its capital is: ' || l_capitol);
    EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('There is no country data available for a country with the ID ' || p_country_id);
END get_country_info;

BEGIN
get_country_info(90);
END;

--Calling a procedure from an anonymous block
BEGIN
get_country_info(95);
END;

--sql
SELECT COUNT(wc.country_id) n_countries, wr.region_name
FROM wf_countries wc
JOIN wf_world_regions wr 
ON wc.region_id = wr.region_id
WHERE wc.region_id = 5 
AND wc.highest_elevation > 2000
AND substr(wc.country_name,1,1) IN ('A')
GROUP BY wr.region_name;
CREATE OR REPLACE PROCEDURE c_w_higher_elevation(p_region_id IN NUMBER, elevation_comp IN NUMBER) AS
l_counts_countries NUMBER;
l_region wf_world_regions.region_name%TYPE;
l_elevation_comp NUMBER;

--PROCEDURE
CREATE OR REPLACE PROCEDURE c_w_higher_elevation(p_region_id IN NUMBER, p_elevation_comp IN NUMBER) AS
l_counts_countries NUMBER;
l_region wf_world_regions.region_name%TYPE;
l_elevation_comp NUMBER;
l_country_initial CHAR(1);
BEGIN
    l_elevation_comp := p_elevation_comp;
    SELECT COUNT(wc.country_id), wr.region_name
    INTO l_counts_countries, l_region
    FROM wf_countries wc
    JOIN wf_world_regions wr 
    ON wc.region_id = wr.region_id
    WHERE wc.region_id = p_region_id 
    AND wc.highest_elevation > l_elevation_comp
    GROUP BY wr.region_name;
    DBMS_OUTPUT.PUT_LINE('There are ' || l_counts_countries || ' in ' || l_region || ' whose highest elevations exceed ' || l_elevation_comp );
END c_w_higher_elevation;

BEGIN
    c_w_higher_elevation(5, 2000);
END;

--another procedure this time with three IN parameters
CREATE OR REPLACE PROCEDURE c_elevation_and_initial(p_region_id IN NUMBER, elevation_comp IN NUMBER, p_c_initial IN CHAR) AS
l_counts_countries NUMBER;
l_region wf_world_regions.region_name%TYPE;
l_elevation_comp NUMBER;
l_country_initial CHAR(1);

BEGIN
    l_elevation_comp := elevation_comp;
    l_country_initial := p_c_initial;
    SELECT COUNT(wc.country_id), wr.region_name
    INTO l_counts_countries, l_region
    FROM wf_countries wc
    JOIN wf_world_regions wr 
    ON wc.region_id = wr.region_id
    WHERE wc.region_id = p_region_id 
    AND wc.highest_elevation > l_elevation_comp
    AND substr(wc.country_name,1,1) IN l_country_initial
    GROUP BY wr.region_name;
    DBMS_OUTPUT.PUT_LINE('There are ' || l_counts_countries || ' in ' || l_region || ' whose highest elevations exceed ' || l_elevation_comp || ' and whose country_name starts with ' || l_country_initial );
END c_elevation_and_initial;

--invoking a procedure
BEGIN
    c_elevation_and_initial(5, 2000, 'A');
END;

BEGIN
    c_elevation_and_initial(5, 2000, 'B');
END;