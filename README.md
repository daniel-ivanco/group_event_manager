# Group Event Manager
This is simple Rails application implementing JSON REST API for managing Group Events.

### Group Event Description
The group event runs for a whole number of days e.g.. 30 or 60. It has attributes to set and update the start, end and duration of the event and calculate the missing value if 2 are given. The event also has a name, description (which supports formatting) and location. The event can be draft or published. To publish all of the fields are required, it can be saved with only a subset of fields before it’s published. When the event is deleted/removed it should be kept in the database and marked as such.
