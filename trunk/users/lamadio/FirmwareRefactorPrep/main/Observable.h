/*
 *  Observable.h
 *  FirmwareRefactorPrep
 *
 *  Created by Lou Amadio on 10/18/08.
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
#ifndef Observable_h
#define Observable_h

class DArray;
class Observer;

class Observable
{
    DArray _observers;
    
public:
    Observable();
    virtual ~Observable();
    
    bool hasObservers();
    void notifyObservers(uint32_t eventId, void* context = NULL);

    void addObserver(Observer* o);
    void removeObserver(Observer* o);
};


class Observer
{
    // Used to remove this class from observables when this is destroyed
    DArray _observing;
public:
    Observer();
    virtual ~Observer();
    
    virtual void notify(uint32_t eventId, void* context);
};


#endif

