import sys
def main(event, context):
    calc = event['k1'] + event['k2'] + ' new Code v2'
    return(calc)

if __name__ == '__main__':
    main(event, context)
