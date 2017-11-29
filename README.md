This was a project I did for credit while I was in college.

The original goal was to make a weather station that would run off a battery, charged by a solar panel during the day. To optimize the solar panel efficiency the panel would be mounted on an arm that would track the sun.

It *mostly* worked.

I decided to post the end result here after collecting dust on my hard drives. I had to keep track of my progress which you can see in the changelog file. My final report for the project is also included. The code I used for the Arduino is in weather.pde.

### The Good
The biggest success of the project was learning to program an Arduino and build some electronics to interface with it. This worked well and I was pretty satisified with the result. I had it tracking barometric pressure, temperature, and humidity via 2 sensors, a digital barometer sensor and a hygrometer sensor. Both reported temperature.

### The Bad
The solar aspect of the project fell very flat. I bought a small solar panel and had trouble getting enough current out of it to be useful. Keep in mind this was in early 2011 and solar technology has improved quite a bit.

Additionally, the solar tracking worked on paper but the sensors were much too close together. In practice the sensor values never varied by enough to be able to discern the direction of light.

### The Ugly
I had high hopes of getting this into an enclosure but wound up not doing it mainly out of time constraints coupled with some downtime when I had surgery for my [Ménière's disease](https://en.wikipedia.org/wiki/M%C3%A9ni%C3%A8re%27s_disease) and the realiziation that the solar charging wasn't going to work out. I wound up mounting it on some wood my wonderful landlord helped me cut.