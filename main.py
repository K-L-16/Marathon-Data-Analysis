import pandas as pd
from geopy.geocoders import Nominatim
from geopy.exc import GeocoderTimedOut

df = pd.read_csv('ff_race_50.csv')

df2 = df.dropna(axis=1).copy()

df2['fullname'] = df2['First'] + ' ' + df2['Last']
df2['Time'] = pd.to_timedelta(df2['Time'])
df2['Total_Minutes'] = (df2['Time'].dt.total_seconds() / 60).round().astype(int)
df2.rename(columns={'Division': 'Gender'}, inplace=True)

def get_lat_long(city, state):
    address = f"{city}, {state}"
    try:
        geolocator = Nominatim(user_agent="running", timeout=10)
        location = geolocator.geocode(address)
        if location:
            return location.latitude, location.longitude
        else:
            return None, None
    except GeocoderTimedOut:
        return None, None

latlongs = df2.apply(lambda x: get_lat_long(x['City'], x['State']), axis=1)
df2['latitude'], df2['longitude'] = zip(*latlongs)

df2['latlong'] = df2['latitude'].astype(str) + ', ' + df2['longitude'].astype(str)

df2.to_csv('ultracleanedupdate_output.csv', index=False)
