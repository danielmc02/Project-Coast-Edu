import asyncio

async def SchedualarMinutes(minutes: int):
    
    while True:
        print("hi")
        minutes = minutes * 60
        await asyncio.sleep(minutes)
    