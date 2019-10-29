import sys
def main(event, context):
    concat = event['k1'] + event['k2']
    return(concat)

if __name__ == '__main__':
    main(event, context)
