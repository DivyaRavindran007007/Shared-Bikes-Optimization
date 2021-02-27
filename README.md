# Shared-Bikes-Optimization
Group project aimed at optimizing shared bikes allocation across stations for the city of Chicago.
In Chicago, Divvy is the bike sharing company that has over 600 stations throughout the city — though, often, you may find those stations empty, especially in crowded and popular areas. This can be detrimental to both the company and the customers looking for a cheap, efficient and healthy way to move in the city.

Please do refer the following page for the details of this project :
https://towardsdatascience.com/optimizing-bike-sharing-allocation-routes-in-chicago-81f17b13a4a5

Assumptions
We identified how our model would be able to solve the problem given the information we had available and what we could reasonably assume:
We had access to every trip for the year 2019, each station’s bike capacity and capacity status per hour. From the weather dataset, we also managed to identify visibility and temperature for every trip.
Considering that allocation would not necessarily have to be performed every hour, we divided weekdays and weekends into timeframes as illustrated above by red lines. Bike allocations are to be performed within those time frames.
As an assumption, we proposed that a van would have a capacity of 20 bikes. This assumption can be easily tweaked in our model.
For simplicity, we also assumed constant and equal traffic for all of Chicago’s regions, which means that the distance between stations is the only factor that impacts the “cost” of a van transportation between two stations. Although this can also be easily changed for the model, the traffic information would be more complicated to gather at this point.
In our model, a van would be responsible only for a certain set of stations. In a future model, we would certainly expand it to consider an indefinite number of vans for all stations at once. However, we found that this type of optimization problem (commonly known as Vehicle Routing Problem, or VRP) is too computationally intensive when considering hundreds of stations at once.


