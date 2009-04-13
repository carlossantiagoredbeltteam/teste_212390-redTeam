/*
 *  Collections.h
 *
 *  Created by Lou Amadio on 9/17/08.
 *  Copyright 2008 OoeyGUI. All rights reserved.
 *     Provided under GPLv3 per gpl-3.0.txt
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
 *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
 *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
 *  FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
 *  COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
 *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
 *  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
 *  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
 *  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
 *  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
 *  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 *  POSSIBILITY OF SUCH DAMAGE. *
 */

#ifndef Collections_h
#define Collections_h

#ifndef max
inline int max(int x, int y) 
{
    return (x > y)?x:y;
}
#endif

typedef void (*DArrayForEach)(void* item, void* context);
#undef int
typedef int (*DArraySortCallback)(const void* item1, const void* item2);


//
// Dynamic Array
//      Dynamic array implementation for Arduino which is memory efficient.
//      Implements several simple datastructures - Queue, Stack, and List
//
class DArray
{
    void** _array;
    size_t _count;
    size_t _allocated;
public:
    DArray();
    ~DArray();
    
    inline size_t count() { return _count; }
    void* item(size_t i);
    void push(void* item);
    void* pop();
    void* dequeue();
    void set(size_t i, void* item);
    bool insert(size_t i, void* item);
    void remove(size_t i);
    bool find(void* item, size_t* index = NULL);
    void* operator[](size_t index) { return item(index); }
    
    DArray* shallowClone();
    
    void sort(DArraySortCallback cb);
    // Do not modify the array during handling
    void foreach(DArrayForEach cb, void* context);
    
    int value(int i) { return (int)item(i); }
    void pushValue(int i) { push((void*)i); }
    int popValue() { return (int)pop(); }
    int dequeueValue() { return (int)dequeue(); }
    bool insertValue(int i, int value) { return insert(i, (void*)value); }
};

#endif

